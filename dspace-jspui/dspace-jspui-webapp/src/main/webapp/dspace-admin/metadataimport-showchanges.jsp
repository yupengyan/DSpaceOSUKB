<%--
- Version: $Revision$
- Date: $Date$
-
- Copyright (c) 2002-2009, The DSpace Foundation.  All rights reserved.
-
- Redistribution and use in source and binary forms, with or without
- modification, are permitted provided that the following conditions are
- met:
-
- - Redistributions of source code must retain the above copyright
- notice, this list of conditions and the following disclaimer.
-
- - Redistributions in binary form must reproduce the above copyright
- notice, this list of conditions and the following disclaimer in the
- documentation and/or other materials provided with the distribution.
-
- - Neither the name of the DSpace Foundation nor the names of their
- contributors may be used to endorse or promote products derived from
- this software without specific prior written permission.
-
- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
- INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
- BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
- OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- DAMAGE.
--%>

<%--
  - Show the changes that might be made
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="org.dspace.app.bulkedit.BulkEditChange" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Collection" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    ArrayList<BulkEditChange> changes = (ArrayList<BulkEditChange>)request.getAttribute("changes");
    boolean changed = ((Boolean)request.getAttribute("changed")).booleanValue();
%>

<dspace:layout titlekey="jsp.dspace-admin.metadataimport.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin" 
               nocache="true">

    <h1><fmt:message key="jsp.dspace-admin.metadataimport.title"/></h1>

    <table class="miscTable">

        <%
            // Display the changes
            int changeCounter = 0;
            for (BulkEditChange change : changes)
            {
                // Get the changes
                ArrayList<DCValue> adds = change.getAdds();
                ArrayList<DCValue> removes = change.getRemoves();
                ArrayList<Collection> newCollections = change.getNewOwningCollections();
                ArrayList<Collection> oldCollections = change.getOldOwningCollections();
                boolean isAChange = false;
                if ((adds.size() > 0) || (removes.size() > 0) ||
                    (newCollections.size() > 0) || (oldCollections.size() > 0))
                {
                    // Show the item
                    if (!change.isNewItem())
                    {
                        Item i = change.getItem();
                        %><tr><th class="oddRowOddCol"><fmt:message key="jsp.dspace-admin.metadataimport.changesforitem"/>: <%= i.getID() %> (<%= i.getHandle() %>)</th><th></th><th></th></tr><%
                    }
                    else
                    {
                        %><tr><th bgcolor="4E9258"><fmt:message key="jsp.dspace-admin.metadataimport.newitem"/>:</th><th></th><th></th></tr><%
                    }
                    changeCounter++;
                    isAChange = true;
                }

                // Show new collections
                for (Collection c : newCollections)
                {
                    String cHandle = c.getHandle();
                    String cName = c.getName();
                    if (!changed)
                    {
                        %><tr><td></td><td bgcolor="4E9258"><fmt:message key="jsp.dspace-admin.metadataimport.addtocollection"/></td><td bgcolor="4E9258">(<%= cHandle %>): <%= cName %></td></tr><%
                    }
                    else
                    {
                        %><tr><td></td><td bgcolor="4E9258"><fmt:message key="jsp.dspace-admin.metadataimport.addedtocollection"/></td><td bgcolor="4E9258">(<%= cHandle %>): <%= cName %></td></tr><%
                    }
                }

                // Show old collections
                for (Collection c : oldCollections)
                {
                    String cHandle = c.getHandle();
                    String cName = c.getName();
                    if (!changed)
                    {
                        %><tr><td></td><td bgcolor="98AFC7"><fmt:message key="jsp.dspace-admin.metadataimport.removefromcollection"/></td><td bgcolor="98AFC7">(<%= cHandle %>): <%= cName %></td></tr><%
                    }
                    else
                    {
                        %><tr><td></td><td bgcolor="98AFC7"><fmt:message key="jsp.dspace-admin.metadataimport.removedfromcollection"/></td><td bgcolor="98AFC7">(<%= cHandle %>): <%= cName %></td></tr><%
                    }
                }

                // Show additions
                for (DCValue dcv : adds)
                {
                    String md = dcv.schema + "." + dcv.element;
                    if (dcv.qualifier != null)
                    {
                        md += "." + dcv.qualifier;
                    }
                    if (dcv.language != null)
                    {
                        md += "[" + dcv.language + "]";
                    }
                    if (!changed)
                    {
                        %><tr><td></td><td bgcolor="4E9258"><fmt:message key="jsp.dspace-admin.metadataimport.add"/> (<%= md %>)</td><td bgcolor="4E9258"><%= dcv.value %></td></tr><%
                    }
                    else
                    {
                        %><tr><td></td><td bgcolor="4E9258"><fmt:message key="jsp.dspace-admin.metadataimport.added"/> (<%= md %>)</td><td bgcolor="4E9258"><%= dcv.value %></td></tr><%
                    }
                }

                // Show removals
                for (DCValue dcv : removes)
                {
                    String md = dcv.schema + "." + dcv.element;
                    if (dcv.qualifier != null)
                    {
                        md += "." + dcv.qualifier;
                    }
                    if (dcv.language != null)
                    {
                        md += "[" + dcv.language + "]";
                    }
                    if (!changed)
                    {
                        %><tr><td></td><td bgcolor="98AFC7"><fmt:message key="jsp.dspace-admin.metadataimport.remove"/> (<%= md %>)</td><td bgcolor="98AFC7"><%= dcv.value %></td></tr><%
                    }
                    else
                    {
                        %><tr><td></td><td bgcolor="98AFC7"><fmt:message key="jsp.dspace-admin.metadataimport.removed"/> (<%= md %>)</td><td bgcolor="98AFC7"><%= dcv.value %></td></tr><%
                    }
                }
            }
        %>

        </table>
        
        <%
            if (!changed)
            {
        %>
        <p align="center">
            <form method="post" action="">
                <input type="hidden" name="type" value="confirm" />
                <input type="submit" name="submit" value="<fmt:message key="jsp.dspace-admin.metadataimport.apply"/>" />
            </form>
            <form method="post" action="">
                <input type="hidden" name="type" value="cancel" />
                <input type="submit" name="submit" value="<fmt:message key="jsp.dspace-admin.general.cancel"/>" />
            </form>
        </p>
        <%
            }
        %>

    </form>
    
</dspace:layout>
