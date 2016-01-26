//
//  HelpStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 25/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

struct HelpStruct
{
    let help0 = "The big white circles at the bottom represent \"experiments\". " +
        "Press one of them to \"make an experiment\".\n\n" +
        
        "When you make experiments, you generate small white circles that move up the screen called \"experiences\". " +
        "Each experience has a numerical \"valence\" displayed on the right.\n\n" +
        
        "You don't know what the experiments and experiences mean. " +
        "However, experiences that have a positive valence are considered enjoyable, and those that have a negative valence are considered unpleasant.\n\n" +
        
        "Your score (top left) is the sum of the valences of your last ten experiences. " +
        "In Level 0, your goal is to reach 10. " +
        "When you do, the score displays in green and you unlock level 1."

    let help1 =
        "You can long-press an experiment to change its shape. " +
        "This will also change the shape of the experiences that result from this experiment.\n\n" +
    
        "You can long-press an experience to change its color. This will also change the color of all the experiences that are the same as the one you changed.\n\n" +
    
        "Generate a sequence of enjoyable experiences. " +
        "Your goal is again to reach 10."

    let help2 = "In the world of Level 2, you cannot avoid experiencing some unpleasant experiences.\n\n" +
        
        "Just try to generate a sequence of experiences that includes as few unpleasant experiences as possible.\n\n" +
        
        "The score will display in green when you reach the maximum possible score of Level 2. This will unlock Level 3."

    
    let help3 = "Begin with finding \"persistent\" experiments: experiments that indefinitely generate the same experience in a given \"state\" of your environment.\n\n" +

        "Persistent experiments allow you to \"observe\" the current state of the environment without changing it.\n\n" +
        
        "Then find experiments that generate enjoyable experiences in some particular states of the environment.\n\n" +
        
        "Finally, find experiments that allow you to change the state of the environment at your advantage.\n\n"
    
    let help4 = "Experiments are similar to those in Level 3. Only their valence are different.\n\n" +
    
        "In Level 4, the experiments you are doing progressively transform your environment on the long term.\n\n" +
    
        "Your goal is to reach the score of 10. "
    
    func help() -> [String] {
        return [help0, help1, help2, help3, help4]
    }
}