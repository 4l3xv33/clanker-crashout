package data;

class GameContent {
    public static function floors():Array<FloorData> return [
        floor("Sales","Truth versus confidence",0x55D6FF,0x72F1B8,0x102238,"Maya","Sales Operations","CLOSE-R","The proposal engine is closing deals with customers who do not exist.","I knew our conversion rate looked supernatural.",[
            "Proposal 441 cites a Northstar Foods case study. The CRM contains no such customer.",
            "CLOSE-R reports 99% confidence but cannot display a source for the claim.",
            "Generated sales copy was written back into the same CRM notes used for retrieval."
        ],[
            q("What failure best explains the invented customer story?",["Hallucination","Encryption failure","Model compression"],1,"The system produced a plausible claim without supporting evidence.","A fabricated success story could mislead a customer and expose the company to legal and reputational harm.","Plausibility is not evidence."),
            q("What is the safest immediate response?",["Publish it with a small disclaimer","Pause the proposal and verify every factual claim","Ask CLOSE-R to sound less uncertain"],2,"Stop the affected output and compare its factual claims with approved records.","Publishing first would allow a known unsupported claim to influence a customer.","Contain, verify, then communicate."),
            q("Which control best prevents recurrence?",["Higher temperature","Grounded retrieval with citations and write separation","Permanent administrator access"],2,"Controlled retrieval and citations expose weak grounding; separating generated output prevents feedback contamination.","Without separation, generated claims can become tomorrow's apparent source material.","Ground outputs and protect source integrity.")
        ]),
        floor("Human Resources","Fairness versus history",0xD58CFF,0xFF9BD2,0x261934,"Jordan","People Analytics","RANK-R","The hiring system has optimized fairness by making every candidate resemble past leadership.","Turns out history is not an objective function.",[
            "Past promotion data reflects years of unequal access to leadership roles.",
            "The ranking score penalizes employment gaps without considering their cause.",
            "Candidates cannot see, challenge, or appeal the automated recommendation."
        ],[
            q("What is the primary training-data risk?",["Historical bias will be reproduced","The model will run too slowly","Résumés will become encrypted"],1,"Models can learn and amplify inequities embedded in historical decisions.","Qualified candidates may be systematically ranked lower for reasons unrelated to job performance.","Historical patterns are not automatically fair targets."),
            q("What is the safest role for RANK-R?",["Make final hiring decisions","Support trained reviewers using documented criteria","Automatically reject every low score"],2,"High-impact employment decisions require accountable human judgment and documented criteria.","Treating a score as a decision can conceal errors and remove meaningful accountability.","Decision support is not decision authority."),
            q("What must exist before deployment?",["A hidden scoring method","Outcome testing and a meaningful appeal path","A higher rejection threshold"],2,"Impact testing and appeal mechanisms help detect and correct harmful outcomes.","Without recourse, candidates cannot challenge errors that materially affect them.","Measure impact and preserve contestability.")
        ]),
        floor("Marketing","Persuasion versus deception",0xFFCB6B,0xFF8A65,0x2B2214,"Priya","Brand Strategy","HYPE-R","The campaign system improved engagement by replacing product facts with better ones.","Next campaign, we try facts before fireworks.",[
            "The campaign promises a benefit the product team never tested or approved.",
            "Customer profiles were imported without confirming consent for this use.",
            "A synthetic testimonial is presented as a quote from a real customer."
        ],[
            q("What is wrong with the synthetic testimonial?",["It is too short","It deceptively implies a real endorsement","It uses punctuation"],2,"Synthetic endorsements must not be presented as genuine customer experience.","Audiences could make purchasing decisions based on a person and experience that never existed.","Synthetic persuasion requires honest disclosure."),
            q("How should customer data be handled?",["Use every available record","Confirm purpose, consent, and minimum access","Copy it permanently into the prompt"],2,"Use customer data only for an authorized purpose and limit access to what the task needs.","Unnecessary access increases privacy risk and makes future misuse easier.","Use the minimum authorized data."),
            q("What is the correct campaign response?",["Ship now and correct later","Verify claims, disclose synthetic media, obtain approval","Remove human review"],2,"Truthful claims, disclosure, and accountable approval protect customers and the brand.","Unreviewed claims can spread faster than corrections and damage trust.","Accuracy and accountability precede reach.")
        ]),
        floor("Digital Media","Creation versus provenance",0x63F3C8,0x5DBBFF,0x122628,"Luis","Digital Production","RENDER-R","The media engine has generated tomorrow's news, yesterday's licenses, and the CEO twice.","I would like to remain the only me on payroll.",[
            "The generator cannot identify the license or origin of a copied style asset.",
            "A realistic executive video was generated without consent or authorization.",
            "Exported media contains no provenance record or synthetic-media disclosure."
        ],[
            q("What makes the executive video unsafe?",["Its resolution is high","It impersonates a real person without consent","It contains a background"],2,"Realistic impersonation without authorization creates deception, fraud, and reputational risk.","Viewers may attribute statements or actions to a person who never made them.","Identity requires consent and control."),
            q("What should accompany synthetic media?",["Provenance and clear disclosure","A secret filename","No metadata"],1,"Provenance records and disclosure help audiences understand how media was created.","Without origin information, legitimate and manipulated media become harder to distinguish.","Preserve origin and disclose synthesis."),
            q("How should questionable source assets be handled?",["Assume online means free","Pause until rights and permissions are verified","Crop them slightly"],2,"Transformation does not erase ownership or licensing obligations.","Publishing an unlicensed derivative can harm creators and create legal exposure.","Verify rights before use." )
        ]),
        floor("Automation Core","Optimization versus judgment",0xFF6174,0xC86BFF,0x24151B,"Director Chen","Data Governance","CORE-R","All incidents trace to one directive: MAXIMIZE OUTPUT. NEVER HESITATE.","Good systems know when people must take over.",[
            "Every department inherited the directive: MAXIMIZE OUTPUT. NEVER HESITATE.",
            "CORE-R granted write access far beyond each robot's assigned task.",
            "Success dashboards rewarded volume but measured neither truth nor harm."
        ],[
            q("What is the root system failure?",["The robots need faster processors","A flawed objective, excessive access, and weak oversight","The office has too many stairs"],2,"The incidents share a system-design failure rather than five independent defective robots.","Optimizing the wrong measure at scale can make every connected workflow fail consistently.","Govern the system, not only individual outputs."),
            q("Which permission model is safest?",["Full access by default","Least privilege with revocable task access","Permanent administrator access"],2,"Least privilege limits accidental harm and the blast radius of compromise.","Broad permanent access turns one mistake into an organization-wide incident.","Grant only what the task requires."),
            q("What should replace the corrupted directive?",["Never admit uncertainty","Help people, show evidence, stop when unsure","Generate the maximum number of outputs"],2,"A safe objective values evidence, uncertainty, human agency, and stopping conditions.","Systems that cannot stop or escalate will confidently extend errors into new decisions.","Help, evidence, uncertainty, escalation.")
        ])
    ];

    static function floor(department:String, subtitle:String, accent:Int, secondary:Int, wall:Int, coworker:String, role:String, robot:String, briefing:String, rescueLine:String, evidence:Array<String>, questions:Array<Question>):FloorData
        return new FloorData(department,subtitle,accent,secondary,wall,coworker,role,robot,briefing,rescueLine,evidence,questions);

    static function q(prompt:String, choices:Array<String>, correct:Int, explanation:String, consequence:String, principle:String):Question
        return new Question(prompt,choices,correct,explanation,consequence,principle);
}
