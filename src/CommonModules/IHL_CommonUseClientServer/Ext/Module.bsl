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

#Region ProgramInterface

// Формирует и выводит сообщение, которое может быть связано с элементом 
// управления формы.
//
// Parameters:
//  Text     - String - текст сообщения.
//  DataKey  - AnyRef - на объект информационной базы.
//              Default value: Undefined.
//                               Ссылка на объект информационной базы, к которому это сообщение относится,
//                               или ключ записи.
//  Filed    - String - наименование реквизита формы.
//              Default value: "".
//  DataPath - String - путь к данным (путь к реквизиту формы).
//              Default value: "".
//  Cancel   - Boolean - выходной параметр.
//              Default value: False.
//                               Всегда устанавливается в значение Истина.
//
// Случаи некорректного использования:
//  1. Передача одновременно параметров DataKey и DataPath.
//  2. Передача в параметре DataKey значения типа отличного от допустимых.
//  3. Установка ссылки без установки поля (и/или пути к данным).
//
Procedure NotifyUser(Val Text, Val DataKey = Undefined, Val Field = "",
        Val DataPath = "", Cancel = False) Export

    Message = New UserMessage;
    Message.Text = Text;
    Message.Field = Field;

    IsObject = False;

    #If Not ТонкийКлиент AND Not ВебКлиент Then
    If DataKey <> Undefined And XMLTypeOf(DataKey) <> Undefined Then
        ValueType = XMLTypeOf(DataKey).TypeName;
        IsObject = Find(ValueType, "Object.") > 0;
    EndIf;
    #EndIf

    If IsObject Then
        Message.SetData(DataKey);
    Else
        Message.DataKey = DataKey;
    EndIf;

    If Not IsBlankString(DataPath) Then
        Message.DataPath = DataPath;
    EndIf;
        
    Message.Message();

    Cancel = True;

EndProcedure // NotifyUser()



// Saves a serialized value to a temporary storage.
//
// Parameters:
//  SerializedValue - Arbitrary - data that should be placed in the temporary storage.
//  Address         - String    - an address in the temporary storage where the data should be placed.
//  TTL             - UUID      - If you transfer UUID forms or address to a repository, the value will be 
//                                  automatically removed after closing the form.
//                                If you transfer UUIDwhich is not a unique form identifier, the value will be 
//                                  removed after the user session is completed.
//                                If the parameter is not specified, the placed value is deleted after the next 
//                                  server request from the common module, during a context or non-context server
//                                  call from a form, server call from a command module or when obtaining a form.
//                      Default value: Undefined.
//
Procedure PutSerializedValueToTempStorage(SerializedValue, Address, 
    TTL = Undefined) Export
    
    If IsTempStorageURL(Address) Then
        PutToTempStorage(SerializedValue, Address);
    Else
        Address = PutToTempStorage(SerializedValue, TTL);
    EndIf;
    
EndProcedure // PutDataToTempStorage()
    

// Serializes the value into XML string representation.
//
// Parameters:
//  Value - Arbitrary - the value to be serialized.
//
// Returns:
//  String - XML string representation.
//
Function SerializeToXML(Value) Export

    XMLWriter = New XMLWriter();
    XMLWriter.SetString();
    XDTOSerializer.WriteXML(XMLWriter, Value);
    Return XMLWriter.Close();

EndFunction // SerializeToXML()



// Creates an instance copy of the specified object.
//
// Parameters:
//  Source - Arbitrary - object that is required to be copied.
//
// Returns:
//  Arbitrary - copy of the source object.
//
// Note:
//  Function can not be used for object types (CatalogObject, DocumentObject etc.).
//
Function CopyRecursive(Source) Export
    
    Var Receiver;
    
    SourceType = TypeOf(Source);
    If SourceType = Type("Structure") Then
        Receiver = CopyStructure(Source);
    ElsIf SourceType = Type("Map") Then
        Receiver = CopyMap(Source);
    ElsIf SourceType = Type("Array") Then
        Receiver = CopyArray(Source);
    ElsIf SourceType = Type("ValueList") Then
        Receiver = CopyValueList(Source);
    #If Server Or ThickClientOrdinaryApplication Or ExternalConnection Then
    ElsIf SourceType = Type("ValueTable") Then
        Receiver = Source.Copy();
    #EndIf
    Else
        Receiver = Source;
    EndIf;
    
    Return Receiver;
    
EndFunction // CopyRecursive()

// Creates copy of the Structure value type.
// 
// Parameters:
//  SourceStructure - Structure - copied structure.
// 
// Returns:
//  Structure - copy of the source structure.
//
Function CopyStructure(SourceStructure) Export
    
    ResultStructure = New Structure;
    
    For Each KeyAndValue In SourceStructure Do
        ResultStructure.Insert(KeyAndValue.Key, CopyRecursive(KeyAndValue.Value));
    EndDo;
    
    Return ResultStructure;
    
EndFunction // CopyStructure()

// Creates value copy of the Match type.
// 
// Parameters:
//  SourceMap - Map - copied map.
// 
// Returns:
//  Map - copy of the source match.
//
Function CopyMap(SourceMap) Export
    
    ResultMap = New Map;
    
    For Each KeyAndValue IN SourceMap Do
        ResultMap.Insert(KeyAndValue.Key, CopyRecursive(KeyAndValue.Value));
    EndDo;
    
    Return ResultMap;
    
EndFunction // CopyMap() 

// Creates the value copy of the Array type.
// 
// Parameters:
//  ArraySource - Array - copied array.
// 
// Returns:
//  Array - copy of the source array.
//
Function CopyArray(ArraySource) Export
    
    ResultArray = New Array;
    
    For Each Item IN ArraySource Do
        ResultArray.Add(CopyRecursive(Item));
    EndDo;
    
    Return ResultArray;
    
EndFunction // CopyArray()

// Create the value copy of the ValuesList type.
// 
// Parameters:
//  SourceList - ValueList - copied values list.
// 
// Returns:
//  ValueList - copy of the source values list.
//
Function CopyValueList(SourceList) Export
    
    ResultList = New ValueList;
    
    For Each ItemOfList IN SourceList Do
        ResultList.Add(CopyRecursive(ItemOfList.Value), 
            ItemOfList.Presentation, 
            ItemOfList.Check, 
            ItemOfList.Picture);
    EndDo;
    
    Return ResultList;
    
EndFunction // CopyValueList() 


#Region StringOperations

Function IsCorrectVariableName(VariableName) Export
    
    If (IsBlankString(VariableName)) Then
        Return False;    
    EndIf;
        
    For Position = 1 To StrLen(VariableName) Do 
        
        Character = Mid(VariableName, Position, 1);
        If Character = "_" Then
            Continue;    
        EndIf;
        
        If Position = 1 И IsNumber(Character) Then
            Return False;    
        EndIf;
        
        If IsSpecialSymbol(Character) Then
            Return False;    
        EndIf;
                
    EndDo;
    
    Return True;    
    
EndFunction // IsCorrectVariableName()

// Check if a character is a special symbol.
//
// Parameters:
//  Character - String - character to be checked.
//
// Returns:
//  Boolean - True if a character is a special symbol; False in other case.
//
Function IsSpecialSymbol(Character) Export
    
    Return ?(IsNumber(Character) 
          Or IsLetter(Character), False, True);
    
EndFunction // IsSpecialSymbol()

// Check if a character is a number.
//
// Parameters:
//  Character - String - character to be checked.
//
// Returns:
//  Boolean - True if a character is a number; False in other case.
//
Function IsNumber(Character) Export
    
    Code = CharCode(Character);
    Return ?(Code <= 47 Or Code >= 58, False, True);
    
EndFunction // IsNumber()

// Check if a character is a letter.
//
// Parameters:
//  Character - String - character to be checked.
//
// Returns:
//  Boolean - True if a character is a letter; False in other case.
//
Function IsLetter(Character) Export
    
    Return ?(IsLatinLetter(Character) 
          Or IsCyrillicLetter(Character), True, False);
    
EndFunction // IsLetter()

// Check if a character is a latin letter.
//
// Parameters:
//  Character - String - character to be checked.
//
// Returns:
//  Boolean - True if a character is a latin letter; False in other case.
//
Function IsLatinLetter(Character) Export
    
    Code = CharCode(Character);
    Return ?((Code > 64 And Code < 91) 
          Or (Code > 96 And Code < 123), True, False);
    
EndFunction // IsLatinLetter() 

// Check if a character is a cyrillic letter.
//
// Parameters:
//  Character - String - character to be checked.
//
// Returns:
//  Boolean - True if a character is a cyrillic letter; False in other case.
//
Function IsCyrillicLetter(Character) Export
    
    Code = CharCode(Character);
    Return ?(Code > 1039 And Code < 1104, True, False);
    
EndFunction // IsCyrillicLetter()

#EndRegion // StringOperations

// Dissembles URI string and returns it as a structure.
// Based on RFC 3986.
//
// Parameters:
//  StringURI - String - reference to the resource in the format:
//                          <schema>://<login>:<password>@<host>:<port>/<path>?<parameters>#<anchor>.
//
// Returns:
//  Structure - with keys:
//      * Schema       - String - schema.
//      * Login        - String - user login.
//      * Password     - String - user password.
//      * ServerName   - String - part <host>:<port> from the StringURI.
//      * Host         - String - host name.
//      * Port         - Number - port number.
//      * PathOnServer - String - part <path >?<parameters>#<anchor> from the StringURI.
//      * Parameters   - Map    - parsed parameters from the StringURI. 
//
Function URIStructure(Val StringURI) Export

    StringURI = TrimAll(StringURI);
    Parameters = New Map;
    
    // Schema
    Schema = "";
    Position = StrFind(StringURI, "://");
    If Position > 0 Then
        Schema = Lower(Left(StringURI, Position - 1));
        StringURI = Mid(StringURI, Position + 3);
    EndIf;

    // Connection string and path on the server.
    ConnectionString = StringURI;
    PathOnServer = "";
    Position = StrFind(ConnectionString, "/");
    If Position > 0 Then
        PathOnServer = Mid(ConnectionString, Position + 1);
        ConnectionString = Left(ConnectionString, Position - 1);
    EndIf;
    
    // Parameters
    Position = StrFind(PathOnServer, "?");
    If Position > 0 Then
        ParametersString = Mid(PathOnServer, Position + 1);        
        ParametersArray = StrSplit(ParametersString, "&");
        For Each Parameter In ParametersArray Do
            Position = StrFind(Parameter, "=");
            If Position > 1 Then
                Parameters.Insert(Left(Parameter, Position - 1), Mid(Parameter, Position + 1));    
            EndIf;    
        EndDo;
    EndIf;
        
    // User information and server name.
    AuthorizeString = "";
    ServerName = ConnectionString;
    Position = StrFind(ConnectionString, "@");
    If Position > 0 Then
        AuthorizeString = Left(ConnectionString, Position - 1);
        ServerName = Mid(ConnectionString, Position + 1);
    EndIf;

    // Login and password.
    Login = AuthorizeString;
    Password = "";
    Position = StrFind(AuthorizeString, ":");
    If Position > 0 Then
        Login = Left(AuthorizeString, Position - 1);
        Password = Mid(AuthorizeString, Position + 1);
    EndIf;

    // Host and port.
    Host = ServerName;
    Port = "";
    Position = StrFind(ServerName, ":");
    If Position > 0 Then
        
        Host = Left(ServerName, Position - 1);
        Port = Mid(ServerName, Position + 1); 
        For Index = 1 To StrLen(Port) Do
            Symbol = Mid(Port, Index, 1);
            If Not IsNumber(Symbol) Then
                Port = "";
                Break;    
            EndIf;
            
        EndDo;
        
        If IsBlankString(Port) Then
            If Schema = "http" Then
                Port = "80";
            ElsIf Schema = "https" Then
                Port = "443";
            EndIf;
        EndIf;
 
    EndIf;

    Result = New Structure;
    Result.Insert("Schema", Schema);
    Result.Insert("Login", Login);
    Result.Insert("Password", Password);
    Result.Insert("ServerName", ServerName);
    Result.Insert("Host", Host);
    Result.Insert("Port", ?(IsBlankString(Port), Undefined, Number(Port)));
    Result.Insert("PathOnServer", PathOnServer);
    Result.Insert("Parameters", Parameters);

    Return Result;

EndFunction // URIStructure()

#EndRegion // ProgramInterface