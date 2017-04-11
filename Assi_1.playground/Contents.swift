//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let arr=[5,1,42,7,4,5,1,3,6,3,0]
arr[0]




func Sort<Omar:Comparable>(_ mArray:[Omar])->[Omar]{
    var ref=0
    var minIndex=0
    var temp :Omar
    var outputArray=mArray
    
    for i in 0..<outputArray.count{
        minIndex=i
        ref=i
        for j in i+1..<outputArray.count{
            if(outputArray[j]<outputArray[minIndex]){
                minIndex=j
            
            }
        }
       
        if(ref != minIndex){
            temp=outputArray[ref]
            outputArray[ref]=outputArray[minIndex]
            outputArray[minIndex]=temp
        }
        
    }
    return outputArray
    
}
let o = Sort(arr)
let r=Sort( ["F","A","CC"])
