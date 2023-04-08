import Foundation
import Generator

struct DocMethodItem {
    struct Param {
        let name: String
        let desc: String
    }
    var name: String
    var shortDescription: String?
    var parameters: [Param]
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
                let param = DocMethodItem.Param(name: newGenerator.nextWord() ?? "", desc: String(newGenerator.remaining()))
                item.parameters.append(param)
                continue
            }
            newGenerator = paramGenerator
            header = Array("- Parameters:")
            if newGenerator.next(header.count) == header {
                while var newParamGenerator = generator.nextLine()?.generator() {
                    newParamGenerator.skipWhitespace()
                    if newParamGenerator.next() == "-" {
                        newParamGenerator.skipWhitespace()
                        let param = DocMethodItem.Param(name: (newParamGenerator.nextWord() ?? "").trimmingCharacters(in: CharacterSet(charactersIn: ":")), desc: String(newParamGenerator.remaining()))
                        item.parameters.append(param)
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
            var list = ""
            for param in item.parameters {
                list.append("<dt>**\(param.name)**</dt><dd>\(param.desc)</dd>")
            }
            result += "| \(item.name) | \(item.shortDescription ?? "") | <dl>\(list)</dl> |\n"
        }
        return result
    }

    public func attributesTable() -> String? {
        if attributeItems.isEmpty {
           return nil 
        }
        var result = "| Attribute | Description | Value |\n"
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
    
    public mutating func nextWord() -> String? {
        if self.atEnd {
            return nil
        }
        var line = ""
        while let next = self.next(), next != " " {
            line.append(next)
        }
        self.reverse()
        return line
    }

}
