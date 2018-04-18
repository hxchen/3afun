---
title: "一个例子学懂lucene--Helloworld"
date: 2013-03-27 23:19:00+08:00
draft: false
tags: ["开源软件","lucene"]
categories: ["开源软件"]
author: "北斗"
---
lucene的一个Helloworld例子，麻雀虽小，五脏俱全。

所需jar包：lucene-analyzers-3.6.2.jar、lucene-core-3.6.2.jar、junit-4.4.jar

```java
import java.io.IOException;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriter.MaxFieldLength;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.LockObtainFailedException;
import org.apache.lucene.store.RAMDirectory;
import org.apache.lucene.util.Version;
import org.junit.Test;

public class HelloWorld {
    @SuppressWarnings("deprecation")
    @Test
    public  void luceneTest(){
        Directory directory  = new RAMDirectory();
        Analyzer analyzer = new StandardAnalyzer(Version.LUCENE_36);
        try {
                 IndexWriter indexWriter = new IndexWriter(directory, analyzer, true, MaxFieldLength.LIMITED);
                 Document document = new Document();
                 Document document2 = new Document();
                 String text  = "我是中国人，我爱中国.";
                 String text2  = "我是中国人，我爱中国.";
                 document.add(new Field("fieldname", text, Field.Store.YES, Field.Index.ANALYZED));
                 document2.add(new Field("fieldname", text2, Field.Store.YES, Field.Index.ANALYZED));
                 indexWriter.addDocument(document);
                 indexWriter.addDocument(document2);
                 indexWriter.optimize();
                 indexWriter.close();
                 // Now search the index;
                 IndexSearcher isearcher = new IndexSearcher(directory);
                 // Parse a simple query that searches for "中国人"
                  String [] queryFileds = {"fieldname"};
                 QueryParser parser = new MultiFieldQueryParser(Version.LUCENE_36, queryFileds, analyzer);
                 Query query = parser.parse("中国人");
                 TopDocs result =  isearcher.search(query, 1000);
                 System.out.println("检索到"+result.totalHits+"条符合条件的数据.");
                 isearcher.close();
                 directory.close();
        } catch (CorruptIndexException e) {
            e.printStackTrace();
        } catch (LockObtainFailedException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
}
```