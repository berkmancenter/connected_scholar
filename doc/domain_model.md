## Domain Model

### User
+  email:String
+  name:String
+  password:Encrypted
+  roles:Array<UserDocumentRole>

### UserDocumentRole
+  user:User
+  document:Document
+  role:Role

### AuthorRole < Role

### ContributorRole < Role

### Document
+  name:String
+  owner:User
+  contributors:Array<User>
+  comments:Array<Comment>
+  active_resources:Array<Resource>
+  recommended_resources:Array<Resource>
+  created_at:DateTime
+  updated_at:DateTime

### Resource
+  title:String
+  authors:Array<String>
+  publisher:String
+  publication_date:String
+  ... potentially a lot more
+  document:Document

### Comment
+  comment_text
+  author:User
+  created_at:DateTime
+  document:Document