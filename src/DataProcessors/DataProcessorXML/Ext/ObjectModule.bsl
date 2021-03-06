﻿////////////////////////////////////////////////////////////////////////////////
// This file is part of IHL (Integration happiness library).
// Copyright © 2016-2017 Petro Bazeliuk.
// 
// This program is free software: you can redistribute it and/or modify 
// it under the terms of the GNU Affero General Public License as 
// published by the Free Software Foundation, either version 3 of the License,
// or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, 
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License 
// along with this program. If not, see <http://www.gnu.org/licenses/agpl-3.0>.
//
////////////////////////////////////////////////////////////////////////////////

Var RefTypesCache;
Var StreamWriter;

#Region FormatDescription

// Number of the formal document from the Internet Engineering Task Force 
// (IETF) that is the result of committee drafting and subsequent review 
// by interested parties.
//
Function FormatStandard() Export
    
    Return "XML 1.0 (Fifth Edition)";
    
EndFunction // FormatStandard()

// Returns link to the formal document from the Internet Engineering Task Force 
// (IETF) that is the result of committee drafting and subsequent review 
// by interested parties.
//
Function FormatStandardLink() Export
    
    Return "https://www.w3.org/TR/2008/REC-xml-20081126/";
    
EndFunction // FormatStandardLink()

// Returns short format name.
//
// Returns:
//  String - format short name.
// 
Function FormatShortName() Export
    
    Return "XML";    
    
EndFunction // FormatShortName()

// Returns full format name.
//
// Returns:
//  String - format full name.
//
Function FormatFullName() Export
    
    Return "Extensible Markup Language";    
    
EndFunction // FormatFullName()

// Returns format file extension.
//
// Returns:
//  String - file extension.
//
Function FormatFileExtension() Export
    
    Return ".xml";
    
EndFunction // FormatFileExtension()

// Returns format media type.
//
// Returns:
//  String - format media type.
//
Function FormatMediaType() Export
    
    Return "application/xml";
    
EndFunction // FormatMediaType()




//Function SupportedTypes() Export
//    
//    ValueList = New ValueList();
//    ValueList.Add("String");
//    ValueList.Add("Number");
//    ValueList.Add("Boolean");
//    ValueList.Add("Null");
//    ValueList.Add("Object");
//    ValueList.Add("Array");
//    Return ValueList;
//    
//EndFunction // SupportedTypes()

//// Check if a type can have nested items.
////
//// Parameters:
////  TypeName  - String - type name.
////
//// Returns:
////   Boolean - True if this type can have nested items; False in other case.
////
//Function TypeCanHaveNestedItems(TypeName) Export
//    
//    If TypeName = "Object" Or TypeName = "Array" Then
//        Return True;
//    EndIf;
//    
//    Return False;
//    
//EndFunction // TypeCanHaveNestedItems()

#EndRegion // FormatDescription

#Region ProgramInterface

// Constructor of stream object.
//
// Parameters:
//  OpenFile - String - output filename.
//             Default value: Empty string.
//
Procedure Initialize(OpenFile = "") Export
    
    RefTypesCache = New Map;
    
    StreamWriter = New XMLWriter;
    If IsBlankString(OpenFile) Then 
        StreamWriter.SetString();
    Else
        
    EndIf;
    
EndProcedure // Initialize()


// This object can have naming restrictions and this problems should be handled. 
//
// Parameters:
//  Mediator   - Arbitrary - reserved, currently not in use.
//  GroupNames - Structure - see function IHLDataComposition.GroupNames.
//
Procedure VerifyGroupNames(Mediator, GroupNames) Export
    
    // No naming restrictions.
    
EndProcedure // VerifyGroupNames()

// This object can have naming restrictions and this problems should be handled. 
//
// Parameters:
//  Mediator        - Arbitrary - reserved, currently not in use.
//  TemplateColumns - Structure - see function IHLDataComposition.TemplateColumns.
//
Procedure VerifyColumnNames(Mediator, GroupNames) Export
    
    // No naming restrictions.
    
EndProcedure // VerifyColumnNames()




// You can can use it to write an XML declaration. 
// If an XML document (and not XML document fragment) is generated, you will need to place an XML declaration in the 
// beginning of the document. Call this method to place an XML declaration in the document. In doing this you will 
// need to place the following text at the beginning of the document: <?xml version="1.0"?>. 
// If encoding was specified when opening a file or setting a string, you should also place the 'encoding' attribute 
// in the declaration. For example: <?xml version="1.0" encoding="UTF-8"?> XML declarations need to be written before 
// other XML write operations.
//
Procedure WriteXMLDeclaration() Export
    StreamWriter.WriteXMLDeclaration();   
EndProcedure // WriteXMLDeclaration()

// Write start element.
//
// Parameters:
//  Name         - String - full name of a recorded element. Can include a prefix. For example: "nsp:weight".
//               - String - local element name (without prefix).
//  NamespaceURI - String - the namespace URI for an element name. 
//                 Default value: Undefined.
//
Procedure WriteStartElement(Name, NamespaceURI = Undefined) Export
    
    If NamespaceURI = Undefined Then
        StreamWriter.WriteStartElement(Name);
    Else        
        StreamWriter.WriteStartElement(Name, NamespaceURI);
    EndIf;
    
EndProcedure // WriteStartElement() 

// Ends XML element writing.
//
Procedure WriteEndElement() Export
    StreamWriter.WriteEndElement();  
EndProcedure // WriteEndElement()

// Writes attribute start.
//
// Parameters:
//  Name         - String - full name of a recorded element. Can include a prefix. For example: "nsp". 
//               - String - local name of an attribute (without a prefix).
//  NamespaceURI - String - the namespace URI for attribute name.  
//                 Default value: Undefined.
//
Procedure WriteStartAttribute(Name, NamespaceURI = Undefined) Export
    
    If NamespaceURI = Undefined Then
        StreamWriter.WriteStartAttribute(Name);
    Else        
        StreamWriter.WriteStartAttribute(Name, NamespaceURI);
    EndIf;
    
EndProcedure // WriteStartAttribute() 

// Ends XML attribute writing.
//
Procedure WriteEndAttribute() Export
    StreamWriter.WriteEndAttribute();  
EndProcedure // WriteEndAttribute()


// Writes element text.
//
// Parameters:
//  Text - String - Content that is placed into an XML element.
//
Procedure WriteText(Text) Export
    StreamWriter.WriteText(Text);    
EndProcedure // WriteText()

// Object through which XML is written.
//
// Parameters:
//  Value - Arbitrary - XML value being written. Parameter type is determined by a 
//                      population of types that XML-serialization was defined for. 
//
Procedure WriteValue(Value) Export
    WriteXML(StreamWriter, Value);    
EndProcedure // WriteValue()


// Completes XML text writing. If writing to a file, the file is closed. If writing to a string, the resultant string 
// will be returned as the method's return value. If writing to file, the method will return an empty string.
//
// Returns:
//  String - XML string.
//
Function Close() Export
    Return StreamWriter.Close();   
EndFunction // Close() 

#EndRegion // ProgramInterface

#Region ServiceProgramInterface

// Outputs sequentially result of the data composition shema into stream object.
//
// Parameters:
//  Item            - DataCompositionResultItem         - a data composition result item.
//  DataCompositionProcessor - DataCompositionProcessor - object that performs data composition.
//  TemplateColumns - Structure - see function IHLDataComposition.TemplateColumns.
//  GroupNames      - Structure - see function IHLDataComposition.GroupNames.
//
Procedure MemorySavingOutput(Item, DataCompositionProcessor, TemplateColumns, 
    GroupNames) Export
    
    Var Level; 

    End = DataCompositionResultItemType.End;
    Begin = DataCompositionResultItemType.Begin;
    BeginAndEnd = DataCompositionResultItemType.BeginAndEnd;
    
    While True Do
        
        If Item = Undefined Then
            Break;
        EndIf;
        
        If Item.ItemType = Begin Then
            
            Item = DataCompositionProcessor.Next();
            If Item.ItemType = Begin Then
                
                Item = DataCompositionProcessor.Next();
                If Item.ItemType = BeginAndEnd Then
                    
                    // It works better for complicated hierarchy.
                    Level = ?(Level = Undefined, 0, Level + 1);
                    
                    StreamWriter.WriteStartElement(GroupNames[Item.Template]);
                    //StreamWriter.WriteStartArray();
                    
                EndIf;
                
            EndIf;
            
        EndIf;
        
        If Level <> Undefined Then
            
            If Item.ItemType = End Then
                
                StreamWriter.WriteEndElement();
                
                Item = DataCompositionProcessor.Next();
                If Item.ItemType = End Then
                    
                    // It works better for complicated hierarchy.
                    Level = ?(Level - 1 < 0, Undefined, Level - 1);
                    
                    StreamWriter.WriteEndElement();
                                   
                // ElsIf Not IsBlankString(Item.Template) Then
                    
                    // It is impossible to get here due to structure of output.
                    
                EndIf;
                
            ElsIf Not IsBlankString(Item.Template) Then
                
                ColumnNames = TemplateColumns[Item.Template];
                
                //StreamWriter.WriteStartObject();
                For Each ColumnName In ColumnNames Do
                    StreamWriter.WriteStartElement(ColumnName.Value);
                    WriteXML(StreamWriter, Item.ParameterValues[ColumnName.Key].Value);
                    StreamWriter.WriteEndElement();
                EndDo;
                
            EndIf;
            
        EndIf;
        
        Item = DataCompositionProcessor.Next();
        
    EndDo;
    
EndProcedure // MemorySavingOutput()

// Outputs fast result of the data composition shema into stream object.
// 
// Note:
//  Additional memory in use.
//
// Parameters:
//  Item            - DataCompositionResultItem         - a data composition result item.
//  DataCompositionProcessor - DataCompositionProcessor - object that performs data composition.
//  TemplateColumns - Structure - see function IHLDataComposition.TemplateColumns.
//  GroupNames      - Structure - see function IHLDataComposition.GroupNames.
//
Procedure FastOutput(Item, DataCompositionProcessor, TemplateColumns, 
    GroupNames) Export 
    
    Var CurrentRow;
    
    OutputTree = New ValueTree;
    OutputTree.Columns.Add("Array");
    OutputTree.Columns.Add("Structure");
    
    OutputStructure = New Structure;
    
    End = DataCompositionResultItemType.End;
    Begin = DataCompositionResultItemType.Begin;
    BeginAndEnd = DataCompositionResultItemType.BeginAndEnd;
    
    While True Do
        
        If Item = Undefined Then
            Break;
        EndIf;
        
        If Item.ItemType = Begin Then
            
            Item = DataCompositionProcessor.Next();
            If Item.ItemType = Begin Then
                
                Item = DataCompositionProcessor.Next();
                If Item.ItemType = BeginAndEnd Then
                
                    Array = New Array;
                    If CurrentRow = Undefined Then
                        OutputStructure.Insert(GroupNames[Item.Template], Array);
                        CurrentRow = OutputTree.Rows.Add();
                    Else
                        CurrentRow.Structure.Insert(GroupNames[Item.Template], Array);
                        CurrentRow = CurrentRow.Rows.Add();
                    EndIf;
                    
                    CurrentRow.Array = Array;
                    
                EndIf;
                
            EndIf;
            
        EndIf;
        
        If CurrentRow <> Undefined Then
            
            If Item.ItemType = End Then
                
                CurrentRow = CurrentRow.Parent;
                
                Item = DataCompositionProcessor.Next();
                If Item.ItemType = End Then
                    CurrentRow = CurrentRow.Parent;
                // ElsIf Not IsBlankString(Item.Template) Then
                    
                    // It is impossible to get here due to structure of output.
                    
                EndIf;
    
            ElsIf Not IsBlankString(Item.Template) Then
                
                Structure = New Structure;
                CurrentRow.Array.Add(Structure);
                CurrentRow = CurrentRow.Rows.Add();
                CurrentRow.Structure = Structure;
                
                ColumnNames = TemplateColumns[Item.Template];
                For Each ColumnName In ColumnNames Do
                    Structure.Insert(ColumnName.Value, Item.ParameterValues[ColumnName.Key].Value);
                EndDo;
                
            EndIf;
            
        EndIf;
        
        Item = DataCompositionProcessor.Next();
        
    EndDo;
    
    For Each KeyAndValue In OutputStructure Do 
        StreamWriter.WriteStartElement(KeyAndValue.Key);
        WriteXML(StreamWriter, KeyAndValue.Value);
        StreamWriter.WriteEndElement();
    EndDo;
    
EndProcedure // FastOutput()

#EndRegion // ServiceProgramInterface

#Region ExternalDataProcessorInfo

// Returns object version.
//
// Returns:
//  String - object version.
//
Function Version() Export
    
    Return "0.0.2.0";
    
EndFunction // Version()

Function BaseDescription() Export
    
    BaseDescription = NStr("en = 'XML (%1) format data processor, ver. %2'; 
        |ru = 'Обработчик формата XML (%1), вер. %2'");
    BaseDescription = StrTemplate(BaseDescription, FormatStandard(), Version());      
    Return BaseDescription;    
    
EndFunction // BaseDescription()

// Returns library guid which is used to identify different implementations 
// of specific format.
//
// Returns:
//  String - library guid. 
//  
Function LibraryGuid() Export
    
    Return "a50f9c26-02ee-4bdf-b3cd-3b978f482949";
    
EndFunction // LibraryGuid()


// Only for internal use.
//
Function ExternalDataProcessorInfo() Export
    
    Version = Version();
    
    Description = BaseDescription();
     
EndFunction // ExternalDataProcessorInfo()

// Only for internal use.
//
Function СведенияОВнешнейОбработке() Export 
    
    // Версия подключаемой функциональности 
    Версия = Version();

    Наименование = BaseDescription();
            
EndFunction // СведенияОВнешнейОбработке()

#EndRegion // ExternalDataProcessorInfo