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
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.xml.sax.ContentHandler;
import org.xml.sax.DTDHandler;
import org.xml.sax.EntityResolver;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;
import org.xml.sax.XMLReader;
import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.helpers.AttributesImpl;

/**
 * The class TeXParser parses TeX hyphenation pattern files and produces SAX events
 */
public class TeXPatternParser implements XMLReader {
    
    public static final String TEX_NAMESPACE = "urn:org:tug:texhyphen";
    private static final int TOP_LEVEL = 3, IN_COMMAND = 4, AFTER_COMMAND = 5, IN_DATA = 6;
    private static final Pattern
    comment = Pattern.compile("%.*"),
    commandStart = Pattern.compile("\\\\"),
    command = Pattern.compile("[a-zA-Z]+"),
    space = Pattern.compile(" +"),
    argOpen = Pattern.compile("\\{"),
    argClose = Pattern.compile("\\}"),
    text = Pattern.compile("[^%\\\\\\{\\}]+");
    private static final AttributesImpl emptyAtts = new AttributesImpl();

    private ContentHandler contentHandler;
    private DTDHandler dtdHandler;
    private EntityResolver entityResolver;
    private ErrorHandler errorHandler;
    private LexicalHandler lexicalHandler;
    
    private void parsePatterns(BufferedReader inbr) throws SAXException, IOException {
        int parseState = TOP_LEVEL;
        Stack<String> stack = new Stack<String>();
        
        contentHandler.startDocument();
        contentHandler.startPrefixMapping("", TEX_NAMESPACE);
        contentHandler.startElement(TEX_NAMESPACE, "tex", "tex", emptyAtts);
        
        for (String line = inbr.readLine(); line != null; line = inbr.readLine()) {
            Matcher matcher = comment.matcher(line).useAnchoringBounds(true);
            int start = 0;
            char[] textchars;
            boolean inComment = false;
            while (start < line.length()) {
                if (matcher.usePattern(comment).lookingAt()) {
                    String text = matcher.group().replace("--", "––");
                    textchars = (text + "\n").toCharArray();
                    if (lexicalHandler != null) {
                        lexicalHandler.comment(textchars, 1, textchars.length - 1);
                    }
                    inComment = true;
                } else if (parseState == IN_DATA && matcher.usePattern(text).lookingAt()) {
                    textchars = matcher.group().toCharArray();
                    contentHandler.characters(textchars, 0, textchars.length);
                } else if (parseState != IN_DATA && matcher.usePattern(space).lookingAt()) {
                    if (parseState == TOP_LEVEL) {
                        textchars = matcher.group().toCharArray();
                        contentHandler.ignorableWhitespace(textchars, 0, textchars.length);
                    }
                } else if (parseState == TOP_LEVEL && matcher.usePattern(commandStart).lookingAt()) {
                    parseState = IN_COMMAND;
                } else if (parseState == IN_COMMAND && matcher.usePattern(command).lookingAt()) {
                    String tag = matcher.group();
                    contentHandler.startElement(TEX_NAMESPACE, tag, tag, emptyAtts);
                    stack.push(tag);
                    parseState = AFTER_COMMAND;
                } else if (parseState == AFTER_COMMAND && matcher.usePattern(argOpen).lookingAt()) {
                    parseState = IN_DATA;
                } else if (parseState == IN_DATA && matcher.usePattern(argClose).lookingAt()) {
                    String tag = stack.pop();
                    contentHandler.endElement(TEX_NAMESPACE, tag, tag);
                    parseState = TOP_LEVEL;
                } else {
                    break;
                }
                start = matcher.end();
                matcher = matcher.region(start, line.length()).useAnchoringBounds(true);
            }
                textchars = "\n".toCharArray();
                if (parseState == IN_DATA && !inComment) {
                    contentHandler.characters(textchars, 0, textchars.length);
                } else if (parseState == TOP_LEVEL && !inComment) {
                    contentHandler.ignorableWhitespace(textchars, 0, textchars.length);
                }
        }

        contentHandler.endElement(TEX_NAMESPACE, "tex", "tex");
        contentHandler.endPrefixMapping(TEX_NAMESPACE);
        contentHandler.endDocument();
    }

    public Reader getReaderFromInputSource(InputSource input) throws IOException {
        Reader reader = input.getCharacterStream();
        String encoding = null;
        if (reader == null) {
            encoding = input.getEncoding();
        }
        if (reader == null) {
            InputStream stream = input.getByteStream();
            if (stream != null) {
                if (encoding == null) {
                    reader = new InputStreamReader(stream);
                } else {
                    reader = new InputStreamReader(stream, encoding);
                }
            }
        }
        if (reader == null) {
            String systemId = input.getSystemId();
            reader = getReaderFromSystemId(systemId, encoding);
        }
        return reader;
    }

    public Reader getReaderFromSystemId(String systemId, String encoding) throws IOException {
        if (systemId == null) {
            throw new IOException("Cannot create a reader from a null systemID");
        }
        if (encoding.isEmpty()) {
            encoding = null;
        }
        Reader reader = null;
        URI uri = null;
        File file = null;
        try {
            uri = new URI(systemId);
        } catch (URISyntaxException e) {
            // handled below
        }
        if (uri == null || !uri.isAbsolute()) {
            file = new File(systemId);
        }
        if (file != null) {
            if (encoding == null) {
                reader = new FileReader(file);
            } else {
                InputStream stream = new FileInputStream(file);
                reader = new InputStreamReader(stream, encoding);
            }
        } else if (uri != null && uri.getScheme().equals("http")) {
            URL url = uri.toURL();
            URLConnection conn = url.openConnection();
            if (encoding == null) {
                encoding = conn.getContentEncoding();
            }
            InputStream stream = conn.getInputStream();
            reader = new InputStreamReader(stream, encoding);
        }
        return reader;
    }
    
    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#getContentHandler()
     */
    public ContentHandler getContentHandler() {
        return contentHandler;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#getDTDHandler()
     */
    public DTDHandler getDTDHandler() {
        return dtdHandler;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#getEntityResolver()
     */
    public EntityResolver getEntityResolver() {
        return entityResolver;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#getErrorHandler()
     */
    public ErrorHandler getErrorHandler() {
        return errorHandler;
    }

    
    /**
     * @return the lexicalHandler
     */
    public LexicalHandler getLexicalHandler() {
        return lexicalHandler;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#getFeature(java.lang.String)
     */
    public boolean getFeature(String arg0)
    throws SAXNotRecognizedException, SAXNotSupportedException {
        throw new SAXNotSupportedException();
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#getProperty(java.lang.String)
     */
    public Object getProperty(String arg0)
    throws SAXNotRecognizedException, SAXNotSupportedException {
        throw new SAXNotSupportedException();
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#parse(org.xml.sax.InputSource)
     */
    public void parse(InputSource input) throws IOException, SAXException {
        Reader reader = getReaderFromInputSource(input);
        if (reader == null) {
            throw new IOException("Could not open input source " + input);
        }
        BufferedReader inbr = new BufferedReader(reader);
        parsePatterns(inbr);
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#parse(java.lang.String)
     */
    public void parse(String systemId) throws IOException, SAXException {
        Reader reader = getReaderFromSystemId(systemId, null);
        if (reader == null) {
            throw new IOException("Could not open input systemID " + systemId);
        }
        BufferedReader inbr = new BufferedReader(reader);
        parsePatterns(inbr);
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#setContentHandler(org.xml.sax.ContentHandler)
     */
    public void setContentHandler(ContentHandler contenthandler) {
        this.contentHandler = contenthandler;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#setDTDHandler(org.xml.sax.DTDHandler)
     */
    public void setDTDHandler(DTDHandler dtdhandler) {
        this.dtdHandler = dtdhandler;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#setEntityResolver(org.xml.sax.EntityResolver)
     */
    public void setEntityResolver(EntityResolver entityresolver) {
        this.entityResolver = entityresolver;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#setErrorHandler(org.xml.sax.ErrorHandler)
     */
    public void setErrorHandler(ErrorHandler errorHandler) {
        this.errorHandler = errorHandler;
    }

    
    /**
     * @param lexicalHandler the lexicalHandler to set
     */
    public void setLexicalHandler(LexicalHandler lexicalHandler) {
        this.lexicalHandler = lexicalHandler;
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#setFeature(java.lang.String, boolean)
     */
    public void setFeature(String arg0, boolean arg1)
    throws SAXNotRecognizedException, SAXNotSupportedException {
        throw new SAXNotSupportedException();
    }

    /* (non-Javadoc)
     * @see org.xml.sax.XMLReader#setProperty(java.lang.String, java.lang.Object)
     */
    public void setProperty(String name, Object value)
    throws SAXNotRecognizedException, SAXNotSupportedException {
        if (name.equals("http://xml.org/sax/properties/lexical-handler")) {
            lexicalHandler = (LexicalHandler) value;
        } else {
            throw new SAXNotSupportedException();
        }
    }

}
