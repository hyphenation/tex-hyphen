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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.sax.TransformerHandler;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

/**
 * Convert modern UTF8 TeX hyphenation patterns to XML format
 */
public final class ConvertTeXPattern {
    
    public static void convert(String[] texPatterns, String outfilePath, boolean useStylesheet,
                               boolean useLanguagedata)
    throws IOException, TransformerException, SAXException, URISyntaxException,
    ParserConfigurationException, CodeMappingException {
        checkCodeMapping();
        Collection<String> languages = codeMapping.keySet();
        convert(texPatterns, outfilePath, useStylesheet, languages);
    }

    public static void convert(String[] texPatterns, String outfilePath, boolean useStylesheet)
    throws IOException, TransformerException, SAXException, URISyntaxException,
    CodeMappingException {
        convert(texPatterns, outfilePath, useStylesheet, null);
    }
    
    /**
     * infile outfile
     * indir outdir (file protocol only)
     * infiles outdir
     * file and http protocols allowed
     * 
     * @param texPatternUri
     * @param outfilePath
     * @param useStylesheet
     * @param texcodes filter of requested tex codes; is allowed to be null 
     * @throws IOException
     * @throws TransformerException
     * @throws SAXException
     * @throws URISyntaxException 
     * @throws CodeMappingException 
     */
    public static void convert(String[] texPatterns, String outfilePath, boolean useStylesheet,
                               Collection<String> texcodes)
    throws IOException, TransformerException, SAXException, URISyntaxException,
    CodeMappingException {
        File outDir = new File(outfilePath);
        boolean oneTexcode = (texcodes != null && texcodes.size() == 1);
        boolean oneInputfile = (texPatterns.length == 1);
        boolean oneFilteredInput = (oneTexcode || oneInputfile);
        if (!oneFilteredInput && !outDir.isDirectory()) {
            throw new IllegalArgumentException
            ("with multiple input files the output path " + outfilePath + " must be a directory");
        }
        for (String texPattern : texPatterns) {
            URI texPatternUri = makeTexPatternUri(texPattern);
            URI[] texPatternUris = makeTexPatternUris(texPatternUri);
            oneInputfile = (texPatternUris.length == 1);
            oneFilteredInput = (oneTexcode || oneInputfile);
            if (!oneFilteredInput && !outDir.isDirectory()) {
                throw new IllegalArgumentException
                ("with an input directory " + texPattern + " the output path " + outfilePath + " must be a directory");
            }
            for (URI t : texPatternUris) {
                TransformationData transformationData = makeTransformationData(t, outDir, texcodes);
                if (transformationData == null) {
                    continue;
                }
                doConvert(t, transformationData, useStylesheet);
            }
        }
    }
    
    /**
     * @param texPattern
     * @return
     * @throws URISyntaxException
     * @throws FileNotFoundException
     */
    private static URI makeTexPatternUri(String texPattern)
    throws URISyntaxException, FileNotFoundException {
        URI texPatternUri;
        texPatternUri = new URI(texPattern);
        String scheme = texPatternUri.getScheme();
        // see if it is a relative file path
        if (scheme == null) {
            File f = new File(texPattern);
            texPatternUri = new URI("file", null, f.getAbsolutePath(), null, null);
            scheme = texPatternUri.getScheme();
        }
        if (scheme == null || !(scheme.equals("http") || scheme.equals("file"))) {
            throw new FileNotFoundException
            ("URI with file or http scheme required for hyphenation pattern file");
        }
        return texPatternUri;
    }

    /**
     * @param outfilePath
     * @param outDir
     * @param texPatternUri
     * @param scheme
     * @return
     * @throws URISyntaxException
     */
    private static URI[] makeTexPatternUris(URI texPatternUri) throws URISyntaxException {
        URI[] texPatternUris;
        texPatternUris = new URI[] {texPatternUri};
        String scheme = texPatternUri.getScheme();
        if (scheme.equals("file")) {
            File dir = new File(texPatternUri);
            if (dir.isDirectory()) {
                ArrayList<URI> l = new ArrayList<URI>();
                FilenameFilter filter = new FilenameFilter() {
                    public boolean accept(File dir, String name) {
                        return name.endsWith(".tex");
                    }
                };
                for (File f : dir.listFiles(filter)) {
                    l.add(new URI("file", null, f.getAbsolutePath(), null, null));
                }
                texPatternUris = l.toArray(texPatternUris);
            }
        }
        return texPatternUris;
    }

    /**
     * @param t
     * @param outDir
     * @param texcodes filter of requested tex codes; is allowed to be null 
     * @return
     * @throws CodeMappingException 
     */
    private static TransformationData makeTransformationData
    (URI t, File outDir, Collection<String> texcodes) throws CodeMappingException {
        File outFile;
        String path = t.getPath();
        String basename = path.substring(path.lastIndexOf('/') + 1);
        String base = basename.substring(0, basename.lastIndexOf('.'));
        // xmlCode, texCode
        String[] codes = mapCode(base);
        // code mapping lists no xmlCode
        if (codes[0] == null) {
            return null;
        }
        if (texcodes != null && !texcodes.contains(codes[1])) {
            return null;
        }
        if (!outDir.isDirectory()) {
            outFile = outDir;
        } else {
            outFile = new File(outDir, codes[0] + ".xml");
        }
        return new TransformationData(outFile, codes[1]);
    }
    
    private static class TransformationData {
        File outFile;
        String texCode;
        TransformationData(File outFile, String texCode) {
            this.outFile = outFile;
            this.texCode = texCode;
        }
    }
    
    private static class CodeMappingException extends Exception {
        public CodeMappingException(Exception e) {
            super(e);
        }
        public CodeMappingException(String m) {
            super(m);
        }
    }

    static Map<String, String> codeMapping;
    static CodeMappingException codeMappingException;
    static {
        try {
            codeMapping = readLanguagedata();
        } catch (ParserConfigurationException e) {
            codeMappingException = new CodeMappingException(e);
        } catch (SAXException e) {
            codeMappingException = new CodeMappingException(e);
        } catch (IOException e) {
            codeMappingException = new CodeMappingException(e);
        }
    }
    
    private static String[] mapCode(String texCode) throws CodeMappingException {
        checkCodeMapping();
        String hyp = "hyph-";
        String xmlCode = texCode;
        if (texCode.startsWith(hyp)) {
            texCode = texCode.substring(hyp.length());
            xmlCode = codeMapping.get(texCode);
        }
        return new String[] {xmlCode, texCode};
    }

    /**
     * @throws CodeMappingException
     */
    private static void checkCodeMapping() throws CodeMappingException {
        if (codeMapping == null) {
            if (codeMappingException != null) {
                throw codeMappingException;
            } else {
                throw new CodeMappingException("Failure initializing code mapping");
            }
        }
    }
    
    public static Map<String,String> readLanguagedata()
    throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory spf = SAXParserFactory.newInstance();
        spf.setNamespaceAware(true);
        SAXParser parser = spf.newSAXParser();
        InputStream is = ConvertTeXPattern.class.getResourceAsStream("languages.xml");
        TexcodeReader texcodeReader = new TexcodeReader();
        parser.parse(is, texcodeReader);
        return texcodeReader.getTexcodes();
    }
    
    private static class TexcodeReader extends DefaultHandler {
        
        private Map<String, String> texcodes = new HashMap<String, String>();

        /* (non-Javadoc)
         * @see org.xml.sax.helpers.DefaultHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes)
         */
        @Override
        public void startElement(String uri, String localName, String qName,
                                 Attributes attributes) throws SAXException {
            if (uri.equals(LanguageDataParser.LANG_NAMESPACE) && localName.equals("language")) {
                String texcode = attributes.getValue("code");
                String fopcode = attributes.getValue("fop-code");
                if (fopcode != null) {
                    texcodes.put(texcode, fopcode);
                }
            }
        }
        
        /**
         * @return the texcodes
         */
        public Map<String,String> getTexcodes() {
            return texcodes;
        }
        
    }
    
    public static void doConvert(URI texPatternUri, TransformationData outdata, boolean useStylesheet)
        throws TransformerException, SAXException, MalformedURLException, IOException, URISyntaxException {

        String scheme = texPatternUri.getScheme();
        InputStream inis = null;
        if (scheme.equals("file")) {
            File in = new File(texPatternUri);
            inis = new FileInputStream(in);
        } else if (scheme.equals("http")) {
            inis = texPatternUri.toURL().openStream();
        } else {
            throw new FileNotFoundException
            ("URI with file or http scheme required for hyphenation pattern file");
        }

        InputSource input = new InputSource(inis);
        input.setSystemId(texPatternUri.toString());
        input.setEncoding("utf-8");
        XMLReader reader = new TeXPatternParser();
        Result result = new StreamResult(outdata.outFile);
        TransformerFactory tf = TransformerFactory.newInstance();
        if (!tf.getFeature(SAXTransformerFactory.FEATURE)) {
            throw new TransformerException("TransformerFactory is not a SAXTransformerFactory");
        }
        SAXTransformerFactory stf = (SAXTransformerFactory) tf;
        TransformerHandler th;
        if (useStylesheet) {
            URL xsltUrl = ConvertTeXPattern.class.getResource("ConvertTeXPattern.xsl");
            File xsltFile = new File(xsltUrl.toURI()); 
            InputStream xsltStream = new FileInputStream(xsltFile);
            Source xsltSource = new StreamSource(xsltStream);
            xsltSource.setSystemId(xsltFile.getAbsolutePath());
            th = stf.newTransformerHandler(xsltSource);
            Transformer tr = th.getTransformer();
            tr.setParameter("tex-code", outdata.texCode);
        } else {
            th = stf.newTransformerHandler();
        }
        reader.setContentHandler(th);
        reader.setProperty("http://xml.org/sax/properties/lexical-handler", th);
        th.setResult(result);
        reader.parse(input);
    }

    /**
     * @param args input URI, output file
     * @throws URISyntaxException if the URI is not correct
     * @throws IOException if a file is not found, or contains illegal content
     * @throws TransformerException 
     * @throws SAXException 
     * @throws ParserConfigurationException 
     * @throws CodeMappingException 
     */
    public static void main(String[] args)
    throws URISyntaxException, IOException, TransformerException, SAXException,
    ParserConfigurationException, CodeMappingException {
        String prefix = "--";
        int i = 0;
        boolean useStylesheet = true;
        boolean useLanguagedata = false;
        Collection<String> texcodes = null;
        while (args[i].startsWith(prefix)) {
            String option = args[i].substring(prefix.length());
            if (option.equals("debug")) {
                useStylesheet = false;
            } else if (option.equals("uselanguagedata") || option.equals("langdata")) {
                useLanguagedata = true;
            } else if (option.equals("texcodes")) {
                texcodes = Arrays.asList(args[++i].split(","));
            } else {
                throw new IllegalArgumentException("Unknown option: " + option);
            }
            ++i;
        }
        if (texcodes != null) {
            convert(Arrays.copyOfRange(args, i, args.length - 1), args[args.length - 1],
                    useStylesheet, texcodes);
        } else {
            convert(Arrays.copyOfRange(args, i, args.length - 1), args[args.length - 1],
                    useStylesheet, useLanguagedata);
        }
    }

}
