import Toybox.Lang;

module Shared {
(:partNumbers)
module PartNumbers {
    var map as Dictionary<String, String> = {
        "006-B1836-00" => "edge_1000",
        "006-B2067-00" => "edge_520",
        "006-B2158-00" => "fr735xt",
        "006-B2187-00" => "d2air",
        "006-B2337-00" => "vivoactive_hr",
        "006-B2432-00" => "fenixchronos",
        "006-B2444-00" => "rino7xx",
        "006-B2512-00" => "oregon7xx",
        "006-B2530-00" => "edge820",
        "006-B2544-00" => "fenix5s",
        "006-B2604-00" => "fenix5x",
        "006-B2656-00" => "approachs60",
        "006-B2691-00" => "fr935",
        "006-B2697-00" => "fenix5",
        "006-B2700-00" => "vivoactive3",
        "006-B2713-00" => "edge1030",
        "006-B2819-00" => "d2charlie",
        "006-B2859-00" => "descentmk1",
        "006-B2886-00" => "fr645",
        "006-B2888-00" => "fr645m",
        "006-B2900-00" => "fenix5splus",
        "006-B2909-00" => "edge130",
        "006-B2988-00" => "vivoactive3m",
        "006-B3011-00" => "edgeexplore",
        "006-B3028-00" => "gpsmap66",
        "006-B3066-00" => "vivoactive3mlte",
        "006-B3076-00" => "fr245",
        "006-B3077-00" => "fr245m",
        "006-B3095-00" => "edge1030bontrager",
        "006-B3110-00" => "fenix5plus",
        "006-B3111-00" => "fenix5xplus",
        "006-B3112-00" => "edge520plus",
        "006-B3113-00" => "fr945",
        "006-B3121-00" => "edge530",
        "006-B3122-00" => "edge830",
        "006-B3196-00" => "d2deltas",
        "006-B3197-00" => "d2delta",
        "006-B3198-00" => "d2deltapx",
        "006-B3224-00" => "vivoactive4s",
        "006-B3225-00" => "vivoactive4",
        "006-B3226-00" => "venu",
        "006-B3246-00" => "marqdriver",
        "006-B3247-00" => "marqaviator",
        "006-B3248-00" => "marqcaptain",
        "006-B3249-00" => "marqcommander",
        "006-B3250-00" => "marqexpedition",
        "006-B3251-00" => "marqathlete",
        "006-B3258-00" => "descentmk2",
        "006-B3287-00" => "fenix6s",
        "006-B3288-00" => "fenix6spro",
        "006-B3289-00" => "fenix6",
        "006-B3290-00" => "fenix6pro",
        "006-B3291-00" => "fenix6xpro",
        "006-B3393-00" => "approachs62",
        "006-B3428-00" => "vivolife",
        "006-B3452-00" => "gpsmap86",
        "006-B3459-00" => "montana7xx",
        "006-B3473-00" => "vivoactive3d",
        "006-B3476-00" => "bounce",
        "006-B3498-00" => "legacysagarey",
        "006-B3499-00" => "legacysagadarthvader",
        "006-B3500-00" => "legacyherocaptainmarvel",
        "006-B3501-00" => "legacyherofirstavenger",
        "006-B3542-00" => "descentmk2s",
        "006-B3558-00" => "edge130plus",
        "006-B3570-00" => "edge1030plus",
        "006-B3589-00" => "fr745",
        "006-B3596-00" => "venusqm",
        "006-B3600-00" => "venusq",
        "006-B3624-00" => "marqadventurer",
        "006-B3638-00" => "enduro",
        "006-B3652-00" => "fr945lte",
        "006-B3703-00" => "venu2",
        "006-B3704-00" => "venu2s",
        "006-B3739-00" => "marqgolfer",
        "006-B3740-00" => "venud",
        "006-B3843-00" => "edge1040",
        "006-B3851-00" => "venu2plus",
        "006-B3869-00" => "fr55",
        "006-B3888-00" => "instinct2",
        "006-B3889-00" => "instinct2s",
        "006-B3905-00" => "fenix7s",
        "006-B3906-00" => "fenix7",
        "006-B3907-00" => "fenix7x",
        "006-B3943-00" => "epix2",
        "006-B3990-00" => "fr255m",
        "006-B3991-00" => "fr255sm",
        "006-B3992-00" => "fr255",
        "006-B3993-00" => "fr255s",
        "006-B4005-00" => "descentg1",
        "006-B4024-00" => "fr955",
        "006-B4061-00" => "edge540",
        "006-B4062-00" => "edge840",
        "006-B4079-00" => "d2mach1",
        "006-B4105-00" => "marq2",
        "006-B4115-00" => "venusq2",
        "006-B4116-00" => "venusq2m",
        "006-B4124-00" => "marq2aviator",
        "006-B4125-00" => "d2airx10",
        "006-B4155-00" => "instinctcrossover",
        "006-B4169-00" => "edgeexplore2",
        "006-B4233-00" => "approachs7042mm",
        "006-B4234-00" => "approachs7047mm",
        "006-B4257-00" => "fr265",
        "006-B4258-00" => "fr265s",
        "006-B4312-00" => "epix2pro42mm",
        "006-B4313-00" => "epix2pro47mm",
        "006-B4314-00" => "epix2pro51mm",
        "006-B4315-00" => "fr965",
        "006-B4336-00" => "gpsmap67",
        "006-B4374-00" => "fenix7spro",
        "006-B4375-00" => "fenix7pro",
        "006-B4376-00" => "fenix7xpro",
        "006-B4394-00" => "instinct2x",
        "006-B4432-00" => "fr165",
        "006-B4433-00" => "fr165m",
    };
}}
