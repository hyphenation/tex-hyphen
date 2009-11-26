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
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.net.URL;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.sax.TransformerHandler;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

/**
 * Convert language data in ruby format to XML format
 */
public final class ConvertLanguageData {
    
    /**
     * @param languageDataPath
     * @throws IOException
     * @throws TransformerException
     * @throws SAXException
     * @throws URISyntaxException 
     */
    public static void convert(String languageDataPath, boolean useStylesheet)
    throws IOException, TransformerException, SAXException, URISyntaxException {

        // input
        InputStream inis = new FileInputStream(languageDataPath);
        InputSource input = new InputSource(inis);
        input.setSystemId(languageDataPath);
        input.setEncoding("utf-8");
        XMLReader reader = new LanguageDataParser();

        // output
        String outPath = languageDataPath.replaceFirst("\\.rb$", ".xml");
        Result result = new StreamResult(outPath);

        // transformation
        TransformerFactory tf = TransformerFactory.newInstance();
        if (!tf.getFeature(SAXTransformerFactory.FEATURE)) {
            throw new TransformerException("TransformerFactory is not a SAXTransformerFactory");
        }
        SAXTransformerFactory stf = (SAXTransformerFactory) tf;
        TransformerHandler th;
        if (useStylesheet) {
            URL xsltUrl = ConvertTeXPattern.class.getResource("ConvertLanguageData.xsl");
            File xsltFile = new File(xsltUrl.toURI()); 
            InputStream xsltStream = new FileInputStream(xsltFile);
            Source xsltSource = new StreamSource(xsltStream);
            xsltSource.setSystemId(xsltFile.getAbsolutePath());
            th = stf.newTransformerHandler(xsltSource);
        } else {
            th = stf.newTransformerHandler();
        }

        // pipeline
        reader.setContentHandler(th);
        reader.setProperty("http://xml.org/sax/properties/lexical-handler", th);
        th.setResult(result);
        reader.parse(input);
    }

    /**
     * @param args
     * @throws IOException
     * @throws TransformerException
     * @throws SAXException
     * @throws URISyntaxException 
     */
    public static void main(String[] args)
    throws IOException, TransformerException, SAXException, URISyntaxException {
        if (args[0].endsWith("--debug")) {
            convert(args[1], false);
        } else {
            convert(args[0], true);
        }
    }

}
