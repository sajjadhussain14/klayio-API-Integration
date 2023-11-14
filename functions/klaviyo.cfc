<cfcomponent displayname="Klaviyo" hint="Integration to Klaviyo" output="true">	
	<cfset this.apikey="Klaviyo-API-Key *************your key here***************">



	 
	<!---- create catalog category--------->
	<cffunction name="createCategory" hint="Creates a new category record">
		<cfargument name="categoryData" required="yes" type="string">
 		
		
		<cfhttp method="post" url="https://a.klaviyo.com/api/catalog-categories/">
			<cfhttpparam name="Authorization" type="HEADER" value="#this.apikey#">
			<cfhttpparam name="Content-Type" type="HEADER" value="application/json">
			<cfhttpparam name="revision" type="HEADER" value="2023-09-15">
			<cfhttpparam name="body" type="body" value="#categoryData#">
		</cfhttp>

		<cfset resp="">
		<cfif cfhttp.statuscode eq "201 Created">
			<cfset resp="SUCCESS">
			<cfset respdata=deserializejson(cfhttp.filecontent)>
			<cfquery name="chkexists" datasource="#application.ds#">
				select * from web_klaviyo_categories where klaviyo_id='#respdata.data.id#'
			</cfquery>
			<cfif chkexists.recordcount gt 0>
				<cfquery name="updrec" datasource="#application.ds#">
					update web_klaviyo_categories set category_name='#respdata.data.category_name#', dlu=getdate() where klaviyo_id='#respdata.data.id#'
				</cfquery>
			<cfelse>
				<cfquery name="insrec" datasource="#application.ds#">
					insert into web_klaviyo_categories (klaviyo_id, category_name,dlu) values ('#respdata.data.id#','#respdata.data.category_name#',getdate())
				</cfquery>
			</cfif>
		<cfelse>
			<cfif  cfhttp.statuscode eq "409" >
				<cfset resp="Same category Already exixts!">
			</cfelse>
				<cfset resp="Failed">
			</cfif>	
		</cfif>
		<cfreturn resp />

 	</cffunction>



	<!---- update catalog category--------->
	<cffunction name="UpdateCategory" hint="Update the category">
		<cfargument name="categoryData" required="yes" type="string">
		<cfargument name="klaviyo_id" required="yes" type="string">
		 
		<cfhttp method="patch" url="https://a.klaviyo.com/api/catalog-categories/#arguments.klaviyo_id#">
			<cfhttpparam name="Authorization" type="HEADER" value="#this.apikey#">
			<cfhttpparam name="Content-Type" type="HEADER" value="application/json">
			<cfhttpparam name="revision" type="HEADER" value="2023-09-15">
			<cfhttpparam name="body" type="body" value="#categoryData#">
		</cfhttp>
		<cfset resp="">
		<cfif cfhttp.statuscode eq "200 OK">
			<cfset respdata=deserializejson(cfhttp.filecontent)>
			<cfset resp="SUCCESS">
			<cfquery name="updrec" datasource="#application.ds#">
				update web_klaviyo_categories set category_name=#respdata.data.name#  dlu=getdate() where klaviyo_id='#arguments.klaviyo_id#'
			</cfquery>
		<cfelse>
			<cfset resp="FAILED">
		</cfif>
		<cfreturn resp />
	</cffunction>





 <cffunction name="createprofile" hint="Creates a new profile/email record">
	<cfargument name="email" required="yes" type="string">
	
	<cfsavecontent variable="req">
	{
	"data": {
		"type": "profile",
		"attributes": {
			"email": "#arguments.email#"
	}
	}
}</cfsavecontent>
	<cfhttp method="post" url="https://a.klaviyo.com/api/profiles/">
<cfhttpparam name="Authorization" type="HEADER" value="#this.apikey#">
<cfhttpparam name="Content-Type" type="HEADER" value="application/json">
<cfhttpparam name="revision" type="HEADER" value="2023-09-15">
<cfhttpparam name="body" type="body" value="#trim(req)#">
</cfhttp>
<cfset resp="">
<cfif cfhttp.statuscode eq "201 Created">
<cfset resp="SUCCESS">
<cfset respdata=deserializejson(cfhttp.filecontent)>
<cfquery name="chkexists" datasource="#application.ds#">
select * from web_klaviyo where email='#arguments.email#'
</cfquery>
<cfif chkexists.recordcount gt 0>
<cfquery name="updrec" datasource="#application.ds#">
update web_klaviyo set klaviyo_id='#respdata.data.id#', dlu=getdate() where email='#arguments.email#'
</cfquery>
<cfelse>
<cfquery name="insrec" datasource="#application.ds#">
insert into web_klaviyo (email, klaviyo_id,dlu) values ('#arguments.email#','#respdata.data.id#',getdate())
</cfquery>

</cfif>

<cfelse>
<cfset resp="FAILED">
</cfif>
    <cfreturn resp />
 </cffunction>
 
 
 
  <cffunction name="updateprofile" hint="Update the Profile">
	<cfargument name="klaviyo_id" required="yes" type="string">
	<cfargument name="email" required="yes" type="string">
	<cfargument name="phone_number" required="yes" type="string">
	<cfargument name="first_name" required="yes" type="string">
	<cfargument name="last_name" required="yes" type="string">
	<cfargument name="address1" required="yes" type="string">
	<cfargument name="address2" required="yes" type="string">
	<cfargument name="city" required="yes" type="string">
	<cfargument name="country" required="yes" type="string">
	<cfargument name="region" required="yes" type="string">
	<cfargument name="zip" required="yes" type="string">
	<cfsavecontent variable="req">{
	"data": {
		"type": "profile",
		"id": "#arguments.klaviyo_id#",
		"attributes": {
			"email": "#arguments.email#",
			"phone_number": "#arguments.phone_number#",
			"first_name": "#arguments.first_name#",
			"last_name": "#arguments.last_name#",
			"location": {
				"address1": "#arguments.address1#",
				"address2": "#arguments.address2#",
				"city": "#arguments.city#",
				"country": "#arguments.country#",
				"region": "#arguments.region#",
				"zip": "#arguments.zip#"
			}
		
		}
	}
}</cfsavecontent>
	<cfhttp method="patch" url="https://a.klaviyo.com/api/profiles/#arguments.klaviyo_id#">
<cfhttpparam name="Authorization" type="HEADER" value="#this.apikey#">
<cfhttpparam name="Content-Type" type="HEADER" value="application/json">
<cfhttpparam name="revision" type="HEADER" value="2023-09-15">
<cfhttpparam name="body" type="body" value="#trim(req)#">
</cfhttp>
<cfset resp="">
<cfif cfhttp.statuscode eq "200 OK">
<cfset resp="SUCCESS">
<cfquery name="updrec" datasource="#application.ds#">
update web_klaviyo set dlu=getdate() where klaviyo_id='#arguments.klaviyo_id#'
</cfquery>
<cfelse>
<cfset resp="FAILED">
</cfif>
    <cfreturn resp />
 </cffunction>
 
 
 <cffunction name="getprofile" hint="Creates a new profile/email record">
	<cfargument name="klaviyo_id" required="yes" type="string">
	
	
	<cfhttp method="get" url="https://a.klaviyo.com/api/profiles/#arguments.klaviyo_id#">
<cfhttpparam name="Authorization" type="HEADER" value="#this.apikey#">
<cfhttpparam name="Content-Type" type="HEADER" value="application/json">
<cfhttpparam name="revision" type="HEADER" value="2023-09-15">
</cfhttp>
<cfset resp="">
<cfif cfhttp.statuscode eq "200 OK">
<cfset resp=cfhttp.filecontent>

<cfelse>
<cfset resp="FAILED">
</cfif>
    <cfreturn resp />
 </cffunction>
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 </cfcomponent>