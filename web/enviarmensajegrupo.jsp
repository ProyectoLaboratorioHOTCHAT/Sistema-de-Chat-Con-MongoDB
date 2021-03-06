<%@page import="com.mongodb.client.MongoCursor"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@ page session="true" %>

<%
    String usuario = "";
    String haySesion = "";
    HttpSession sesionOk = request.getSession();
    if (sesionOk.getAttribute("usuario") == null) {
%>

<jsp:forward page="index.jsp">
    <jsp:param name="error" value="Es obligatorio identificarse"/>
</jsp:forward>

<%    } else {
        usuario = (String) sesionOk.getAttribute("usuario");
        haySesion =  (String)sesionOk.getAttribute("haySesion");
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="org.bson.Document"%>
<%@page import="com.mongodb.client.gridfs.model.GridFSUploadOptions"%>
<%@page import="com.mongodb.client.gridfs.GridFSBuckets"%>
<%@page import="com.mongodb.client.gridfs.GridFSBucket"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="org.apache.tomcat.util.http.fileupload.util.Streams"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItemStream"%>
<%@page import="org.apache.tomcat.util.http.fileupload.FileItemIterator"%>
<%@page import="org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload"%>

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
<%@page import="com.mongodb.*"%>

<%
            ServletFileUpload Data = new ServletFileUpload();
            FileItemIterator iter = Data.getItemIterator(request);
            FileItemStream item =iter.next();
            InputStream stream = item.openStream();
            String UsuarioD = Streams.asString(stream);
            while (iter.hasNext()) {
                item = iter.next();
                stream = item.openStream();
                if (item.isFormField()) {
                    String Mensaje = Streams.asString(stream);
                    if(Mensaje.compareTo("") != 0){
                        MongoClient mCliente = new MongoClient("127.0.0.1",27017);
                        DB db = mCliente.getDB("yptBD");
                        DBCollection coleccion = db.getCollection("Mensajes");
                        BasicDBObject documento = new BasicDBObject();
                        documento.put("visit", usuario);
                        documento.put("host",UsuarioD);
                        documento.put("mensaje", Mensaje);
                        documento.put("fecha", "Enero 2018");
			documento.put("tipo", 0);
                        documento.put("estado", 0);
                        coleccion.insert(documento);
                        MongoDatabase baseDatos = mCliente.getDatabase("yptBD"); 
                        MongoCollection<Document> miColeccion = baseDatos.getCollection(UsuarioD);
                        MongoCursor<Document> cursor;
                        cursor = miColeccion.find().iterator();
                        String A  = "";
                        
                        while (cursor.hasNext()) {
                            BasicDBObject G = BasicDBObject.parse( cursor.next().toJson());
                            A =G.getString("nombre");
                            if (!A.equals(usuario.toString()))
                            {
                                DBCollection coleccion1 = db.getCollection("GrNotify");
                                BasicDBObject documento1 = new BasicDBObject();
                                documento1.put("grupo", UsuarioD);
                                documento1.put("host", usuario);
                                documento1.put("mensaje", Mensaje);
                                documento1.put("usuario",A);
                                documento1.put("visto", 0);
                                coleccion1.insert(documento1);
                                
                                %>
                        <jsp:useBean id="miLogin23" class="Autentication.cLogin" scope="session">
            
                        </jsp:useBean>
                        <%
                        miLogin23.setaUsuario(usuario);
                        miLogin23.ContarMensajeEnvi();    
                        
                            }
                            
                            
                        }
                        cursor.close();
                        
                    }
                }
                else
                    {
                       String nombreArch = item.getName();
                       out.print(nombreArch);
                       if(nombreArch.compareTo("") != 0)
                        {
                            MongoClient mCliente = new MongoClient("127.0.0.1",27017);
                            DB db = mCliente.getDB("yptBD");
                            DBCollection coleccion = db.getCollection("Mensajes");
                            BasicDBObject documento = new BasicDBObject();
                            documento.put("visit", usuario);
                            documento.put("host",UsuarioD);
                            documento.put("mensaje", nombreArch); 
                            documento.put("fecha", "Enero 2018");
                            documento.put("tipo", 1); 
                            documento.put("estado", 0);
                            coleccion.insert(documento);
                            MongoDatabase baseDatos = mCliente.getDatabase("yptBD"); 
                        MongoCollection<Document> miColeccion = baseDatos.getCollection(UsuarioD);
                        MongoCursor<Document> cursor;
                        cursor = miColeccion.find().iterator();
                        String A  = "";
                        
                        while (cursor.hasNext()) {
                            BasicDBObject G = BasicDBObject.parse( cursor.next().toJson());
                            A =G.getString("nombre");
                            if (!A.equals(usuario.toString()))
                            {
                                DBCollection coleccion1 = db.getCollection("GrNotify");
                                BasicDBObject documento1 = new BasicDBObject();
                                documento1.put("grupo", UsuarioD);
                                documento1.put("host", usuario);
                                documento1.put("mensaje", nombreArch);
                                documento1.put("usuario",A);
                                documento1.put("visto", 0);
                                coleccion1.insert(documento1);
                            }
                            
                            
                        }
                        cursor.close();
                            %>
                        <jsp:useBean id="miLogin2" class="Autentication.cLogin" scope="session">
            
                        </jsp:useBean>
                        <%
                        miLogin2.setaUsuario(usuario);
                        miLogin2.ContarMensajeEnvi();
                        
                            GridFSBucket gridFSBucket = GridFSBuckets.create(baseDatos, "misArchivos");
                            GridFSUploadOptions opciones = new GridFSUploadOptions()
                            .chunkSizeBytes(1024);
                            ObjectId fileId = gridFSBucket.uploadFromStream(nombreArch, stream, opciones);
                        }
                          
                    }
            }
%>


<jsp:forward page="ChatGrupalMain.jsp">
        <jsp:param name = "NameGrupo" value="<%=UsuarioD%>"/>
 </jsp:forward>