<cfoutput>
<cfset klaviyoObj=createObject("component","functions.klaviyo")>

<cfquery name="checkTable" datasource="#application.ds#">
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'web_klaviyo_categories')
    BEGIN
        CREATE TABLE web_klaviyo_categories (
            klaviyo_id NVARCHAR(255),
            category_name NVARCHAR(255),
            dlu DATE
        )
    END
</cfquery>

<!---- create category---->
<cfset categoryData={
	"data": {
		"type": "catalog-category",
		"attributes": {
			"external_id": "345",
			"name": "abc",
			"integration_type": "$custom",
			"catalog_type": "$default"
		} 
	}
}>
<cfdump var="#klaviyoObj.createCategory(serializeJson(categoryData),'345')#">

<!---- update category---->

<cfset categoryUpdateData={
	"data": {
		"type": "catalog-category",
		"id": "1234567",
		"attributes": {
			"name": "abc"
		} 
	}
}>

<!-----
<cfdump var="#klaviyoObj.UpdateCategory(serializeJson(categoryUpdateData),'345')#">
---->





</cfoutput>