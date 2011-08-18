# Connected Scholar Resource Search Integration

## Primo Central
[http://primo-trial.hosted.exlibrisgroup.com:1701](http://primo-trial.hosted.exlibrisgroup.com:1701)

Primo Central is a cross-disciplinary resource that covers hundreds of millions of e-resources, such as journal articles, e-books, and digital collections.

Features:
+  Fielded resource search
+  Suggestions for related searches
+  Recommendations: 'Users interested in this article also expressed an interest in ..."

Primo does not provide an open API that would allow ConnectedScholar to integrate with it.

Primo does provide an RSS feed for any search. The URL for the RSS feed could be manipulated to provide programmatic access to the search engine.  However, the hyperlinks in the RSS do not appear to be correct.

Another possible integration point is the Primo "Send To" feature.  This allows a particular resource to be emailed or sent to other common link aggregators.  The email feature does not seem to be working.  We could attempt to integrate via a third party (such as del.icio.us).

Primo is still in a trial period.

## PRESTO Tools
[http://webservices.lib.harvard.edu/](http://webservices.lib.harvard.edu/)

PRESTO is a RESTful data lookup service.  The API provides the following features:
+  Request bibliographic information from HOLLIS or VIA.
+  Request HOLLIS item availability information.
+  Request library or archive information stored in the Harvard Libraries portal database.
+  Determine if the requesting IP address is coming from an “in library” computer.
+  Search HOLLIS or HOLLIS Classic.

The PRESTO service restricts requests to pre-registered IP addresses.  This would require any server that ConnectedScholar is running on to be registered with PRESTO.  This could be problematic if deployed in the cloud.  It is also unclear if access would be allowed for developer machines.

## LibraryCloud/ShelfLife
[http://librarylab.law.harvard.edu/](http://librarylab.law.harvard.edu/)

Its unclear how to get access to these tools.

