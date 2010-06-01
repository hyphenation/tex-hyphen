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
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.xml.sax.Attributes;
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
public class LanguageDataParser implements XMLReader {
    
    public static final String LANG_NAMESPACE = "urn:org:tug:texhyphen:languagedata";
    public static int lineLength = 72;
    private static final int TOP_LEVEL = 3, IN_LANG = 4;
    private static final Pattern
    comment = Pattern.compile("#.*"),
    langStart = Pattern.compile("{", Pattern.LITERAL),
    langEnd = Pattern.compile("}", Pattern.LITERAL),
    dataline = Pattern.compile("\"([^\"]+)\" ?=> ?\"([^\"]+)\","),
    keywordline = Pattern.compile("\"([^\"]+)\" ?=> ?(false|true|nil),"),
    listline = Pattern.compile("\"([^\"]+)\" ?=> ?\\[(\"[^\"]+\"(?:,\"[^\"]+\")*)\\],"),
    datalistline = Pattern.compile("\"([^\"]+)\" ?=> ?\\[([^,]+(?:,[^,]+)*)\\],"),
    space = Pattern.compile("[ \\t]+");
    private static final AttributesImpl emptyAtts = new AttributesImpl();

    private ContentHandler contentHandler;
    private DTDHandler dtdHandler;
    private EntityResolver entityResolver;
    private ErrorHandler errorHandler;
    private LexicalHandler lexicalHandler;
    
    private void parseLanguageData(BufferedReader inbr) throws SAXException, IOException {
        int parseState = TOP_LEVEL;
        Language lang = null;
        
        contentHandler.startDocument();
        contentHandler.startPrefixMapping("", LANG_NAMESPACE);
        contentHandler.startElement(LANG_NAMESPACE, "languages", "languages", emptyAtts);
        
        for (String line = inbr.readLine(); line != null; line = inbr.readLine()) {
            Matcher matcher = comment.matcher(line).useAnchoringBounds(true);
            int start = 0;
            while (start < line.length()) {
                if (matcher.usePattern(comment).lookingAt()) {
                    processComment(matcher.group(), parseState == TOP_LEVEL ? null : lang);
                } else if (matcher.usePattern(space).lookingAt()) {
                    // do nothing
                } else if (parseState == TOP_LEVEL && matcher.usePattern(langStart).lookingAt()) {
                    parseState = IN_LANG;
                    lang = new Language();
                } else if ((parseState == IN_LANG) && matcher.usePattern(langEnd).lookingAt()) {
                    pushoutLanguage(lang);
                    lang = null;
                    parseState = TOP_LEVEL;
                } else if (parseState == IN_LANG
                        && (matcher.usePattern(dataline).lookingAt()
                                || matcher.usePattern(keywordline).lookingAt())) {
                    String key = matcher.group(1);
                    String value = matcher.group(2);
                    processDataline(key, value, lang);
                } else if (parseState == IN_LANG
                        && (matcher.usePattern(listline).lookingAt()
                                || matcher.usePattern(datalistline).lookingAt())) {
                    String key = matcher.group(1);
                    String values = matcher.group(2);
                    processListline(key, values, lang);
                } else {
                    break;
                }
                start = matcher.end();
                matcher = matcher.region(start, line.length()).useAnchoringBounds(true);
            }
        }

        contentHandler.endElement(LANG_NAMESPACE, "languages", "languages");
        contentHandler.endPrefixMapping(LANG_NAMESPACE);
        contentHandler.endDocument();
    }
    
    static Collection<String> attributeKeys;
    static {
        attributeKeys = new Vector<String>();
        attributeKeys.add("code");
        attributeKeys.add("name");
        attributeKeys.add("use-old-patterns");
        attributeKeys.add("use-new-loader");
        attributeKeys.add("encoding");
        attributeKeys.add("exceptions");
    }
    
    private void processComment(String comment, Language lang) throws SAXException {
        comment = comment.replace("--", "––");
        if (!comment.endsWith(" ")) {
            comment = comment + " ";
        }
        if (lang == null) {
            char[] textchars = comment.toCharArray();
            if (lexicalHandler != null) {
                lexicalHandler.comment(textchars, 1, textchars.length - 1);
            }
        } else {
            lang.elements.add(new Element("comment", comment));
        }

    }
    
    private void processDataline(String key, String value, Language lang) {
        key = key.replace('_', '-');
        if (value.equals("nil")) {
            value = "";
        }
        if (attributeKeys.contains(key)) {
            lang.atts.addAttribute("", key, key, "CDATA", value);
        } else {
            lang.elements.add(new Element(key, value));
        }
    }

    private void processListline(String key, String valuesString, Language lang) {
        key = key.replace('_', '-');
        valuesString = valuesString.replace("\"", "");
        String[] values = valuesString.split(",[ \\t]*");
        if (attributeKeys.contains(key)) {
            StringBuilder attValue = new StringBuilder();
            for (String value : values) {
                if (!value.equals("nil")) {
                    attValue.append(" " + value);
                }
            }
            lang.atts.addAttribute("", key, key, "CDATA", attValue.toString());
        } else if (key.equals("hyphenmin")) {
            key = "hyphen-min";
            AttributesImpl atts = new AttributesImpl();
            atts.addAttribute("", "before", "before", "CDATA", values[0]);
            atts.addAttribute("", "after", "after", "CDATA", values[1]);
            lang.elements.add(new Element(key, "", atts));
        } else {
            key = key.replaceAll("s$", "");
            for (String value : values) {
            if (value.equals("nil")) {
                    value = "";
                }
                lang.elements.add(new Element(key, value));
            }
        }
    }

    private void pushoutLanguage(Language lang) throws SAXException {
        contentHandler.startElement(LANG_NAMESPACE, "language", "language", lang.atts);
        Iterator<Element> iter = lang.elements.iterator();
        while (iter.hasNext()) {
            Element elt = iter.next();
            char[] text = elt.content.toCharArray();
            if (elt.tag.equals("comment")) {
                if (lexicalHandler != null) {
                    lexicalHandler.comment(text, 1, text.length - 1);
                }
            } else {
                contentHandler.startElement(LANG_NAMESPACE, elt.tag, elt.tag, elt.atts);
                contentHandler.characters(text, 0, text.length);
                contentHandler.endElement(LANG_NAMESPACE, elt.tag, elt.tag);
            }
        }
        contentHandler.endElement(LANG_NAMESPACE, "language", "language");
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
        parseLanguageData(inbr);
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
        parseLanguageData(inbr);
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
    
    private static class Element {
        String tag;
        String content;
        Attributes atts;
        Element(String tag, String content) {
            this(tag, content, LanguageDataParser.emptyAtts);
        }
        Element(String tag, String content, Attributes atts) {
            this.tag = tag;
            this.content = content;
            this.atts = atts;
        }
    }
    
    private static class Language {
        AttributesImpl atts;
        List<Element> elements;
        Language() {
            atts = new AttributesImpl();
            elements = new Vector<Element>();
        }
    }

}
