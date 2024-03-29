

import SwiftUI

struct Question: Equatable, Hashable {
    let text: String
    let answers: [String]
    let rightAnswer: String

    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.text == rhs.text
            && lhs.answers == rhs.answers
            && lhs.rightAnswer == rhs.rightAnswer
    }

    init(q: String, a: [String], correctAnswer: String) {
        text = q
        answers = a
        rightAnswer = correctAnswer
    }
}

struct Topic: Identifiable, Hashable {
    let id: Int
    let name: String
    let articleURL: URL // HTML file path in Downloads folder without extension
    let questions: [Question]
    let img_id: String
}


class Globalvar: ObservableObject {
    @Published var unlockedTopicIDs: [Int]
    
    init() {
        self.unlockedTopicIDs = UserDefaults.unlockedTopicIDs.isEmpty ? [1] : UserDefaults.unlockedTopicIDs
    }
}


struct UnitsView: View {
    
    let units: [String: [Topic]] = [
        K.unit1: [
            Topic(id: 1, name: K.topic11, articleURL: K.article11URL, questions: K.quiz11, img_id: "img1"),
            Topic(id: 2, name: K.topic12, articleURL: K.article12URL, questions: K.quiz12, img_id: "img2")
        ],
        K.unit2: [
            Topic(id: 3, name: K.topic21, articleURL: K.article21URL, questions: K.quiz21, img_id: "img3"),
            Topic(id: 4, name: K.topic22, articleURL: K.article22URL, questions: K.quiz22, img_id: "img4"),
            Topic(id: 5, name: K.topic23, articleURL: K.article23URL, questions: K.quiz23, img_id: "img5"),
            Topic(id: 6, name: K.topic24, articleURL: K.article24URL, questions: K.quiz24, img_id: "img6")
        ]
            // Add more units here
    ]
    var body: some View {
        VStack {
            topbar_1() //2 different topbar() and topbar_1() for variation.
            
            List {
                ForEach(units.keys.sorted(), id: \.self) { unit in
                    
                    Section(header: Text(unit).bold()) {
                        ForEach(units[unit]!, id: \.id) { topic in
                            TopicItemView(topic: topic)
                        }
                        
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct topbar_1: View{
    var body: some View{
        HStack{
            Image("inapp_icon")
                .resizable()
                .frame(width:60, height:60)
            
        }
    }
}

struct topbar: View{
    var body: some View{
        HStack{
            Image("inapp_icon")
                .resizable()
                .frame(width:60, height:60)
            Spacer()
            VStack(alignment: .leading){
                Text("Units")
                    .font(.title)
                    .bold()
                    .padding(.all)
            }
            Spacer()
            Image("")
                .resizable()
                .frame(width:60, height:60)
            
        }
    }
}


    
struct TopicItemView: View {
    var topic: Topic // Replace TopicType with your actual type
     // Whether the topic is unlocked
    
    @State var unlockedTopicIDs: [Int] = UserDefaults.unlockedTopicIDs.isEmpty ? [1] : UserDefaults.unlockedTopicIDs
    
    var body: some View {
        HStack{ //hstack for desc and lock
            
            NavigationLink(destination: TopicDetailView(topic: topic)) {
                HStack {
                    let img = topic.img_id
                    Image(img)
                        .resizable()
                        .frame(width:80, height:80)
                        .cornerRadius(10)
                    Spacer()
                    VStack(alignment: .leading){
                        Spacer()
                        Text(topic.name)
                            .font(.system(.title3, design: .rounded))
                            .bold()
                        if unlockedTopicIDs.contains(topic.id) {
                            Text("Unlocked") // Unlocked

                        } else {
                            Text("Locked") // Locked
                                .italic()
                        }
                        Spacer()
                    }
                    Spacer()
                    if unlockedTopicIDs.contains(topic.id) {
                        Image(systemName: "lock.open.fill") // Unlocked
                    } else {
                        Image(systemName: "lock.fill") // Locked
                    }
                }
                .foregroundColor(unlockedTopicIDs.contains(topic.id) ? .primary : .secondary)
            }
            .disabled(!unlockedTopicIDs.contains(topic.id))
        }
    }
}






struct UnitsView_Previews: PreviewProvider {
    static var previews: some View {
        UnitsView()
    }
}
