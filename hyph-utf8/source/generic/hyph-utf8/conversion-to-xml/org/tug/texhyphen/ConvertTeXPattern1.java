/*
 * Copyright Simon Pepping 2009
 * 
 * The copyright owner licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* $Id$ */

package org.tug.texhyphen;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.sax.TransformerHandler;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

/**
 * Convert modern UTF8 TeX hyphenation patterns to XML format
 */
public final class ConvertTeXPattern1 {
    
    private static int INTRO = 0, PATTERNS = 1, EXCEPTIONS = 2, COMMENT_LENGTH = 80,
    TOP_LEVEL = 3, IN_COMMAND = 4, AFTER_COMMAND = 5, IN_DATA = 6;

    /**
     * Comment strings
     */
    public static String texCommentChar = "%", xmlCommentStart = "<!--", xmlCommentEnd = "-->";
    
    public static void Convert4(String texPatternUri, String outfilePath)
    throws IOException, TransformerException, SAXException {
        Convert4(texPatternUri, outfilePath, true);
    }
    
    public static void Convert4(String texPatternUri, String outfilePath, boolean useStylesheet)
    throws IOException, TransformerException, SAXException {
        InputSource input = new InputSource();
        input.setSystemId(texPatternUri);
        input.setEncoding("utf-8");
        XMLReader reader = new TeXPatternParser();
        Result result = new StreamResult(outfilePath);
        TransformerFactory tf = TransformerFactory.newInstance();
        if (!tf.getFeature(SAXTransformerFactory.FEATURE)) {
            throw new TransformerException("TransformerFactory is not a SAXTransformerFactory");
        }
        SAXTransformerFactory stf = (SAXTransformerFactory) tf;
        TransformerHandler th;
        if (useStylesheet) {
            InputStream xsltStream = ConvertTeXPattern.class.getResourceAsStream("ConvertTeXPattern.xsl");
            Source xsltSource = new StreamSource(xsltStream);
            th = stf.newTransformerHandler(xsltSource);
        } else {
            th = stf.newTransformerHandler();
        }
        reader.setContentHandler(th);
        reader.setProperty("http://xml.org/sax/properties/lexical-handler", th);
        th.setResult(result);
        reader.parse(input);
    }

    public static void Convert3(String texPatternUri, String outfilePath)
    throws IOException, TransformerException {
        InputSource input = new InputSource();
        input.setSystemId(texPatternUri);
        input.setEncoding("utf-8");
        XMLReader reader = new TeXPatternParser();
        Source source = new SAXSource(reader, input);
        Result result = new StreamResult(outfilePath);
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.transform(source, result);
    }

    public static void Convert2(String texPatternUri, String outfilePath)
    throws URISyntaxException, IOException {
        URI texPattern;
        texPattern = new URI(texPatternUri);
        String scheme = texPattern.getScheme();
        if (scheme == null) {
            File f = new File(texPatternUri);
            texPattern = new URI("file", null, f.getAbsolutePath(), null, null);
            scheme = texPattern.getScheme();
        }
        if (scheme == null || !(scheme.equals("file") || scheme.equals("http"))) {
            throw new FileNotFoundException
            ("URI with file or http scheme required for hyphenation pattern file");
        }
        
        File f = new File(outfilePath);
        if (f.exists()) {
            f.delete();
        }
        f.createNewFile();
        FileOutputStream fw = new FileOutputStream(f);
        OutputStreamWriter ow = new OutputStreamWriter(fw, "utf-8");
        
        URI inuri = texPattern;
        InputStream inis = null;
        if (scheme.equals("file")) {
            File in = new File(inuri);
            inis = new FileInputStream(in);
        } else if (scheme.equals("http")) {
            inis = inuri.toURL().openStream();
        }
        InputStreamReader insr = new InputStreamReader(inis, "utf-8");
        BufferedReader inbr = new BufferedReader(insr);

        ow.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
        ow.write("<hyphenation-info>\n");

        Pattern comment = Pattern.compile("%.*");
        Pattern commandStart = Pattern.compile("\\\\");
        Pattern command = Pattern.compile("[a-zA-Z]+");
        Pattern space = Pattern.compile(" +");
        Pattern argOpen = Pattern.compile("\\{");
        Pattern argClose = Pattern.compile("\\}");
        Pattern text = Pattern.compile("[^%\\\\\\{\\}]+");
        int parseState = TOP_LEVEL;
        Map<String,String> commands = new HashMap<String,String>();
        commands.put("patterns", "patterns");
        commands.put("hyphenation", "exceptions");
        Stack<String> stack = new Stack<String>();
        
        for (String line = inbr.readLine(); line != null; line = inbr.readLine()) {
            Matcher matcher = comment.matcher(line).useAnchoringBounds(true);
            int start = 0;
            while (start < line.length()) {
                if (matcher.usePattern(comment).lookingAt()) {
                    ow.write("<!-- " + matcher.group() + " -->");
                    System.out.println("comment: " + matcher.group() + ", from " + matcher.start() + " to " + matcher.end());
                } else if (parseState != IN_DATA && matcher.usePattern(space).lookingAt()) {
                    ow.write(matcher.group());
                    System.out.println((matcher.end() - matcher.start()) + "spaces" + ", from " + matcher.start() + " to " + matcher.end());
                } else if (parseState == TOP_LEVEL && matcher.usePattern(commandStart).lookingAt()) {
                    parseState = IN_COMMAND;
                    System.out.println("starting command" + ", from " + matcher.start() + " to " + matcher.end());
                } else if (parseState == IN_COMMAND && matcher.usePattern(command).lookingAt()) {
                    System.out.println("command " + matcher.group() + ", from " + matcher.start() + " to " + matcher.end());
                    String tag = commands.get(matcher.group());
                    if (tag == null) {
                        break;
                    }
                    ow.write("<" + tag + ">");
                    stack.push(tag);
                    parseState = AFTER_COMMAND;
                } else if (parseState == AFTER_COMMAND && matcher.usePattern(argOpen).lookingAt()) {
                    parseState = IN_DATA;
                    System.out.println("argument open" + ", from " + matcher.start() + " to " + matcher.end());
                } else if (parseState == IN_DATA && matcher.usePattern(argClose).lookingAt()) {
                        ow.write("</" + stack.pop() + ">");
                    parseState = TOP_LEVEL;
                    System.out.println("argument close" + ", from " + matcher.start() + " to " + matcher.end());
                } else if (parseState == IN_DATA && matcher.usePattern(text).lookingAt()) {
                    ow.write(matcher.group());
                    System.out.println("text: " + matcher.group() + ", from " + matcher.start() + " to " + matcher.end());
                } else {
                    break;
                }
                start = matcher.end();
                matcher = matcher.region(start, line.length()).useAnchoringBounds(true);
            }
            ow.write("\n");
        }

        ow.write("</hyphenation-info>\n");
        ow.flush();
        ow.close();
        inbr.close();
    }

    /**
     * Convert one pattern file from TeX to XML 
     * @param texPatternUri the URI of the TeX pattern file, file or http scheme
     * @param outfilePath the output file
     * @throws URISyntaxException if the URI is not correct
     * @throws IOException if a file is not found, or contains illegal content
     */
    public static void Convert(String texPatternUri, String outfilePath)
    throws URISyntaxException, IOException {
        URI texPattern;
        texPattern = new URI(texPatternUri);
        String scheme = texPattern.getScheme();
        if (scheme == null || !(scheme.equals("file") || scheme.equals("http"))) {
            throw new FileNotFoundException
            ("URI with file or http scheme required for hyphenation pattern file");
        }
        
        File f = new File(outfilePath);
        if (f.exists()) {
            f.delete();
        }
        f.createNewFile();
        FileOutputStream fw = new FileOutputStream(f);
        OutputStreamWriter ow = new OutputStreamWriter(fw, "utf-8");
        
        URI inuri = texPattern;
        InputStream inis = null;
        if (scheme.equals("file")) {
            File in = new File(inuri);
            inis = new FileInputStream(in);
        } else if (scheme.equals("http")) {
            inis = inuri.toURL().openStream();
        }
        InputStreamReader insr = new InputStreamReader(inis, "utf-8");
        BufferedReader inbr = new BufferedReader(insr);

        ow.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
        ow.write("<hyphenation-info>\n");

        int state = INTRO;
        int clenBase = COMMENT_LENGTH - xmlCommentStart.length() - 1 - xmlCommentEnd.length(); 

        for (String line = inbr.readLine(); line != null; line = inbr.readLine()) {
            if (state == INTRO
                    && !(line.startsWith(texCommentChar)
                            || line.startsWith("\\patterns{") || line.startsWith("\\hyphenation{")
                            || line.equals("") || line.matches("^\\s+$"))) {
                throw new IOException("The intro should only contain comment");
            }
            String lineContent = line;
            String lineComment = null;
            if (line.contains(texCommentChar)) {
                int index = line.indexOf(texCommentChar);
                lineContent = line.substring(0, index);
                lineComment = line.substring(index + texCommentChar.length());
            }
            if (lineContent.contains("\\patterns{")) {
                state = PATTERNS;
                lineContent = lineContent.replaceFirst("\\\\patterns\\{", "<patterns>");
            }
            if (lineContent.contains("}") && state == PATTERNS) {
                lineContent = lineContent.replaceFirst("}", "</patterns>");
            }
            if (lineContent.contains("\\hyphenation{")) {
                state = EXCEPTIONS;
                lineContent = lineContent.replaceFirst("\\\\hyphenation\\{", "<exceptions>");
            }
            if (lineContent.contains("}") && state == EXCEPTIONS){
                lineContent = lineContent.replaceFirst("}", "</exceptions>");
            }
            if (lineContent.contains("}") || lineContent.contains("\\")) {
                throw new IOException("Unrecognized markup: " + lineContent);
            }
            if (lineComment != null) { 
                int clen = clenBase - lineContent.length();
                lineComment = String.format(xmlCommentStart + "%-" + clen + "s"
                                            + " " + xmlCommentEnd, new Object[] {lineComment});
            }
            ow.write(lineContent + (lineComment==null?"":lineComment) + "\n");
        }

        ow.write("</hyphenation-info>\n");
        ow.flush();
        ow.close();
        inbr.close();
    }
    
    /**
     * @param args input URI, output file
     * @throws URISyntaxException if the URI is not correct
     * @throws IOException if a file is not found, or contains illegal content
     * @throws TransformerException 
     * @throws SAXException 
     */
    public static void main(String[] args) throws URISyntaxException, IOException, TransformerException, SAXException {
        if (args.length == 3) {
            Convert4(args[0], args[1], Boolean.parseBoolean(args[2]));
        } else {
            Convert4(args[0], args[1]);
        }
    }

}
