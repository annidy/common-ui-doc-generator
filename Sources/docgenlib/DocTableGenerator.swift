import Foundation
import Generator

struct DocMethodItem {
    var name: String
    var shortDescription: String?
    var parameters: [String]
}

struct DocAttributeItem {
    var name: String
    var shortDescription: String?
    var defaultValue: String?
}

public class DocTableGenerator {

    private var methodItems: [DocMethodItem] = []
    private var attributeItems: [DocAttributeItem] = []

    public init() {
        
    }

    public func appendMethod(name: String, docs: String) {
        var item = DocMethodItem(name: name, shortDescription: nil, parameters: [])
        var generator = docs.generator()
        item.shortDescription = generator.nextLine()
        while let next = generator.nextLine() {
            var paramGenerator = next.generator()
            paramGenerator.skipWhitespace()
            var newGenerator = paramGenerator
            var header = Array("@param")
            if newGenerator.next(header.count) == header {
                newGenerator.skipWhitespace()
                item.parameters.append(String(newGenerator.remaining()))
                continue
            }
            newGenerator = paramGenerator
            header = Array("- Parameters:")
            if newGenerator.next(header.count) == header {
                while var newParam = generator.nextLine()?.generator() {
                    newParam.skipWhitespace()
                    if newParam.next() == "-" {
                        newParam.skipWhitespace()
                        item.parameters.append(String(newParam.remaining()))
                    } else {
                        break
                    }
                }
            }
        }
        methodItems.append(item)
    }

    public func appendAttribute(name: String, docs: String) {
        var item = DocAttributeItem(name: name, shortDescription: nil, defaultValue: nil)
        var generator = docs.generator()
        item.shortDescription = generator.nextLine()
        while let next = generator.nextLine() {
            var defaultValueGenerator = next.generator()
            defaultValueGenerator.skipWhitespace()
            var newGenerator = String(defaultValueGenerator.remaining()).generator()
            var header: [String.Element] = Array("@value")
            if newGenerator.next(header.count) == header {
                newGenerator.skipWhitespace()
                item.defaultValue = String(newGenerator.remaining())
            }
            newGenerator = String(defaultValueGenerator.remaining()).generator()
            header = Array("- Value:")
            if newGenerator.next(header.count) == header {
                newGenerator.skipWhitespace()
                item.defaultValue = String(newGenerator.remaining())
            }
        }
        attributeItems.append(item)
    }

    public func methodsTable() -> String? {
        if methodItems.isEmpty {
            return nil
        }
        var result = "| Method | Description | Parameter |\n"
        result += "| --- | --- | --- |\n"
        for item in methodItems {
            result += "| \(item.name) | \(item.shortDescription ?? "") | \(item.parameters.joined(separator: "<br/>")) |\n"
        }
        return result
    }

    public func attributesTable() -> String? {
        if attributeItems.isEmpty {
           return nil 
        }
        var result = "| Attribute | Description | Default value |\n"
        result += "| --- | --- | --- |\n"
        for item in attributeItems {
            result += "| \(item.name) | \(item.shortDescription ?? "") | \(item.defaultValue ?? "") |\n"
        }
        return result
    }
}

extension Generator where Container == String {

    public mutating func nextLine() -> String? {
        if self.atEnd {
            return nil
        }
        var line = ""
        while let next = self.next(), next != "\n" {
            line.append(next)
        }
        return line
    }

}
