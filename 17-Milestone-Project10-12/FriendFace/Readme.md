# Milestone V: Projects 10-12

[Day 60](https://www.hackingwithswift.com/100/swiftui/60) – Milestone: Projects 10-12 <br />
[Day 61](https://www.hackingwithswift.com/100/swiftui/61) – Time for SwiftData

## Challenges

From [Milestone: Projects 10-12](https://www.hackingwithswift.com/guide/ios-swiftui/5/3/challenge)

>It’s time for you to build an app from scratch, and it’s a particularly expansive challenge today: your job is to use URLSession to download some JSON from the internet, use Codable to convert it to Swift types, then use NavigationStack, List, and more to display it to the user.
>
>Your first step should be to examine the JSON. The URL you want to use is this: https://www.hackingwithswift.com/samples/friendface.json – that’s a massive collection of randomly generated data for example users.
>
>As you can see, there is an array of people, and each person has an ID, name, age, email address, and more. They also have an array of tag strings, and an array of friends, where each friend has a name and ID.
>
>How far you implement this is down to you, but at the very least you should:
>
>- Fetch the data and parse it into User and Friend structs.
>- Display a list of users with a little information about them, such as their name and whether they are active right now.
>- Create a detail view shown when a user is tapped, presenting more information about them, including the names of their friends.
>- Before you start your download, check that your User array is empty so that you don’t keep starting the download every time the view is shown.
>If you’re not sure where to begin, start by designing your types: build a User struct with properties for name, age, company, and so on, then a Friend struct with id and name. After that, move onto some URLSession code to fetch the data and decode it into your types.
>
>You might notice that the date each user registered has a very specific format: 2015-11-10T01:47:18-00:00. This is known as ISO-8601, and is so common that there’s a built-in dateDecodingStrategy called .iso8601 that decodes it automatically.
>
>While you’re building this, I want you to keep one thing in mind: this kind of app is the bread and butter of iOS app development – if you can nail this with confidence, you’re well on your way to a full-time job as an app developer.

From [Time for SwiftData](https://www.hackingwithswift.com/100/swiftui/61)

>If I had said to you that your challenge was to build an app that fetches data from the network, decodes it into native Swift types, then displays it using a navigation stack – oh, and by the way, the whole thing should be powered using SwiftData… well, suffice to say you’d probably have balked at the challenge.
>
>So, instead I’ve pulled a fast one: yesterday I had you work on the fundamentals of the app, making sure you understand the JSON, got your Codable support right, thought your UI through, and more.
>
>Today I’m going to do what inevitably happens in any real-world project: I’m going to add a new feature request to the project scope. This is sometimes called “scope creep”, and it’s something you’re going to face on pretty much every project you ever work on. That doesn’t mean planning ahead is a bad idea – as Winston Churchill said, “those who plan do better than those who do not plan, even though they rarely stick to their plan.”
>
>So, we’re not sticking to the plan; we’re adding an important new feature that will force you to rethink the way you’ve built your app, will hopefully lead you to think about how you structured your code, and also give you practice in a technique that you ought to be thoroughly familiar with by now: SwiftData.
>
>Yes, your job today is to expand your app so that it uses SwiftData. Your boss just emailed you to say the app is great, but once the JSON has been fetched they really want it to work offline. This means you need to use SwiftData to store the information you download, then use your SwiftData models to display the views you designed – you should only fetch the data once.
>
>The end result will hopefully be the same as if I had given you the task all at once, but segmenting it in two like this hopefully makes it seem more within reach, while also giving you the chance to think about how well you structured your code to be adaptable as change requests come in.

## Screenshots

<img src="https://github.com/ivanov-mi/100-days-of-SwiftUI/assets/12073144/58790418-01fd-420e-830a-d577c8f0682d" width="300">
<img src="https://github.com/ivanov-mi/100-days-of-SwiftUI/assets/12073144/1a748698-df65-4b6d-b14b-3de12982e1e8" width="300">
