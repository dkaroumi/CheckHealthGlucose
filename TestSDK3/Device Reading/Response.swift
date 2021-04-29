//
//  Location.swift
//  Simpleupload
//
//  Created by Oscar Luong on 2021-03-24.
//

import Foundation


struct Response: Codable {
    
    var phenomenonTime: String
    var resultTime: String
    var result: Result
    let FeatureOfInterest: [String: Int]
    let Datastream: [String: Int]

}
extension Response {
    struct Result: Codable {
        let resourceType: String
        let id: String
        let meta: Profile
        let identifier: [Identifier]
        let status: String
        let code: Code
        let subject: Reference
        var component: [Component]
        
        
        init(_ _resourceType: String,_ _id: String,_ _meta: Profile, _ _identifier: Identifier,_ _status: String, _ _code: Code, _ _subject: Reference, _ _component: Component) {
            resourceType = _resourceType
            id = _id
            meta = _meta
            identifier = [_identifier]
            status = _status
            code = _code
            subject = _subject
            component = [_component]
        }
    }
    struct Profile: Codable {
        var profile: [String] = [String]()
        
        mutating func append(_ _profile: String) -> Void {
            profile.append(_profile)
        }
        
    }
    
    
    struct Identifier: Codable {
        let use: String
        let system: String
        let value: String
        
        init(_ _use: String,_ _system: String,_ _value: String) {
            use = _use
            system = _system
            value = _value

        }
    }
    
    struct Reference: Codable {
        let reference: String
        
        init(_ _reference: String){
            reference = _reference
        }
    }
    
    struct Coding: Codable {
        let system: String
        let code: String
        let display: String
        
        init(_ _system: String,_ _code: String,_ _display: String) {
            system = _system
            code = _code
            display = _display

        }
    }
    
    struct Code: Codable {
        var coding: [Coding]
        let text: String?
        
        init(_ _coding: [Coding], _ _text: String) {
            coding = _coding
            text = _text
        }
        
        init(_ _coding: [Coding]) {
            coding = _coding
            text = nil
        }
        mutating func append(_ _coding: Coding) -> Void {
            coding.append(_coding)
        }
    }
    
    struct ValueQuantity: Codable {
        var value: Double
        let unit: String
        let system: String
        let code: String
        
        init(_ _value: Double, _ _unit: String, _ _system: String,_ _code: String) {
            value = _value
            unit = _unit
            system = _system
            code = _code
        }
    }
    
    struct Component: Codable {
        let code: Code
        var valueQuantity: ValueQuantity
        
        init(_ _code: Code, _ _valueQuantity: ValueQuantity) {
            code = _code
            valueQuantity = _valueQuantity
        }
    }
} //Structs

extension Response {
    enum RootKeys: String, CodingKey {
        case phenomenonTime, resultTime, result = "result", featureOfIntereset = "FeatureOfInterest", datastream = "Datastream"
    }
    
    enum ResultKeys: String, CodingKey {
        case resourceType = "resourceType", id = "id", meta="meta", identifier="identifier", status = "status"
             , code = "code", subject="subject", component = "component"
    }
    
    enum MetaKeys: String, CodingKey{
        case profile = "profile"
    }
    
    enum IdentifierKeys: String, CodingKey{
        case use="use", system="system", value="value"
    }
    
    enum CodeKeys: String, CodingKey{
        case coding = "coding", text = "text", system = "system", code = "code", display = "display"
    }
    
    enum SubjectKeys: String, CodingKey{
        case reference = "reference"
    }
    
    enum ComponentKeys: String, CodingKey {
        case code = "code", valueQuantity = "valueQuantity", coding = "coding", value = "value", unit = "unit", system = "system"
    }
    
    enum FoiKeys: String, CodingKey {
        case iotid = "@iot.id"
    }
} //Enums keys

extension Response {
    init() {
        phenomenonTime = String()
        resultTime = String()
        result = Result("", "", Profile(), Identifier("","",""), "", Code([Coding("","","")]), Reference(""), Component(Code([Coding("","","")]), ValueQuantity(0, "","","")))
        FeatureOfInterest = ["": 0]
        Datastream = ["": 0]
    }
} //Empty initializer

extension Response {

    init(from decoder: Decoder) throws {
        
        
        // json file
        let container = try decoder.container(keyedBy: RootKeys.self)
        //result
        let resultContainer = try container.nestedContainer(keyedBy: ResultKeys.self, forKey: .result)
        
        //id
        let id = try resultContainer.decode(String.self, forKey: .id)
        //resourcetype
        let resourceType = try resultContainer.decode(String.self, forKey: .resourceType)
        
        //Meta
        let metaContainer = try resultContainer.nestedContainer(keyedBy: MetaKeys.self, forKey: .meta)
        var profileContainer = try metaContainer.nestedUnkeyedContainer(forKey: .profile)
        let meta = try profileContainer.decode(String.self)
        var profile = Profile()
        profile.append(meta)
        
        //Identifier
        var identifierContainer = try resultContainer.nestedUnkeyedContainer(forKey: .identifier)
        
        let insideContainer = try identifierContainer.nestedContainer(keyedBy: IdentifierKeys.self)
        let use = try insideContainer.decode(String.self, forKey: .use)
        let system = try insideContainer.decode(String.self, forKey: .system)
        let value = try insideContainer.decode(String.self, forKey: .value)
        let identifier = Identifier(use, system, value)
        
        //status
        let status = try resultContainer.decode(String.self, forKey: .status)
        
        //code
        let codeContainer = try resultContainer.nestedContainer(keyedBy: CodeKeys.self, forKey: .code)
        let text = try codeContainer.decode(String.self, forKey: .text)
        //coding
        var codingContainer = try codeContainer.nestedUnkeyedContainer(forKey: .coding)
        let insidecodingContainer = try codingContainer.nestedContainer(keyedBy: CodeKeys.self)
        var system2 = try insidecodingContainer.decode(String.self, forKey: .system)
        var code2 = try insidecodingContainer.decode(String.self, forKey: .code)
        var display2 = try insidecodingContainer.decode(String.self, forKey: .display)
        let code = Code([Coding(system2,code2,display2)],text)
        
        //subject
        let subjectContainer = try resultContainer.nestedContainer(keyedBy: SubjectKeys.self, forKey: .subject)
        let referenceobj = try subjectContainer.decode(String.self, forKey: .reference)
        let reference = Reference(referenceobj)
        
        //component
        var componentContainer = try resultContainer.nestedUnkeyedContainer(forKey: .component)
        let insidecomponentContainer = try componentContainer.nestedContainer(keyedBy: ComponentKeys.self)
        let component2Container = try insidecomponentContainer.nestedContainer(keyedBy: ComponentKeys.self, forKey: .code)
        
        //Create code
        var codeplacer = Code([])
        
        var coding2Container = try component2Container.nestedUnkeyedContainer(forKey: .coding)
        while !coding2Container.isAtEnd {
            let insidecoding2Container = try coding2Container.nestedContainer(keyedBy: CodeKeys.self)
            
            system2 = try insidecoding2Container.decode(String.self, forKey: .system)
            code2 = try insidecoding2Container.decode(String.self, forKey: .code)
            display2 = try insidecoding2Container.decode(String.self, forKey: .display)
            
            let codeElement = Coding(system2, code2, display2)
            codeplacer.append(codeElement)
        }
        //Create valueQuantity
        let valueQuantityContainer = try insidecomponentContainer.nestedContainer(keyedBy: ComponentKeys.self, forKey: .valueQuantity)
        let value2 = try valueQuantityContainer.decode(Double.self, forKey: .value)
        let unit = try valueQuantityContainer.decode(String.self, forKey: .unit)
        let system3 = try valueQuantityContainer.decode(String.self, forKey: .system)
        let code3 = try valueQuantityContainer.decode(String.self, forKey: .code)
        
        let valueQuantity = ValueQuantity(value2, unit, system3, code3)
        
        //Assemble
        let component = Component(codeplacer, valueQuantity)
        
        //FeatureOfInterest
        let foiContainer = try? container.nestedContainer(keyedBy: FoiKeys.self, forKey: .featureOfIntereset)
        var iotIdValue = try foiContainer?.decode(Int.self, forKey: .iotid)
        iotIdValue = (iotIdValue ?? 2)
        
        
        //Datastream
        let datastreamContainer = try? container.nestedContainer(keyedBy: FoiKeys.self, forKey: .datastream)
        var datastreamValue = try datastreamContainer?.decode(Int.self, forKey: .iotid)
        datastreamValue = (datastreamValue ?? -2)
        
        phenomenonTime = try container.decode(String.self, forKey: .phenomenonTime)
        resultTime = try container.decode(String.self, forKey: .resultTime)
        result = Result(resourceType, id, profile, identifier, status, code, reference, component)
        FeatureOfInterest = ["@iot.id":iotIdValue!]
        Datastream = ["@iot.id":datastreamValue!]
    }
} //Non-empty inittializer

extension Response {
    mutating func changeResult(_ _value: Double){
        result.component[0].valueQuantity.value = _value
    }
    mutating func changePhenomenonTime(_ _value: String){
        phenomenonTime = _value
    }
    mutating func changeResultTime(_ _value: String){
        resultTime = _value
    }
} // Change functions

extension String.StringInterpolation {
      mutating func appendInterpolation(_ response: Response) {
        appendLiteral("Time: \(response.phenomenonTime) Result: \(response.result.component[0].valueQuantity.value)")
   }
} //to String



