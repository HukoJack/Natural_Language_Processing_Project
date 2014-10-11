library(shiny)

# load models
load("blogs.model.hashed")
load("news.model.hashed")
load("twitter.model.hashed")

# load unigrams
load("blogs.unigram.hashed")
load("news.unigram.hashed")
load("twitter.unigram.hashed")

# predictive function
predictNextWord <- function(char, model, hash, unigram, uni_hash, clean=TRUE) {
    # predicts next 5 most probable words for the character string 
    
    # status check if the "space" after the last word in char string was typed
    initial <- char
    status <- substr(char, nchar(char), nchar(char)) == " "
    
    # cleaning char
    if (clean) {
        char <- gsub("[<>]", "", char)
        char <- gsub("[[:digit:]]+[:.,-][[:digit:]]+", " <digit> ", char)
        char <- gsub("[[:digit:]]+", " <digit> ", char)
        char <- gsub("[[:alnum:].-]+@[[:alnum:].-]+", " <e-mail> ", char)
        for (smile in c("x-p", "o.o", "[=:;][boqje#pds]")) {
            char <- gsub(smile, "", char)
        }
        char <- gsub("\\?+\\!+|\\!+\\?+", "?", char)
        char <- gsub(";+", ",", char)
        char <- gsub('[)(:#%$^\\~{}&+=@/"_]+', "", char)
        for (punct in c("!", "?", ".", ",")) {
            pattern <- paste0("\\", punct, "+")
            replacement <- paste0(" ", punct, " ")
            char <- gsub(pattern, replacement, char)
            char <- gsub("\\s+", " ", char)
        }
        reg <- " screw | wank[a-z]*|b[o0][o0]bs|l3i[a-z]ch|knob|or[ia]f[ai][cs]|[a-z]damn |d[iy]ck|q[uw]e[ei]r| arse|[ck]awk| gay|retard|s[kc]anc*k|t[ie]+t[sz]|slut|puss[ye]|vul+va|vag*[i1]*j*i*na|pola[ck]|phu[ck]|pe[ie]*n[a1iu]+s|pac*k[iy]| anal | anus |butt[wh-]|clit|crap|pu[tl][eao] |jar*c*k[\\s-]*off|blow\\s*job|ji[zs]+|nazi|w*h[o0]+a*r|a[s]*h[o0]le|sh[i1!y]t|mas+t[eu]*rbai*t|n[i1]+g+[eu]*r| a[sz][sz]|bas+t[ae]rd|b[!i1][a7]*tch|c[o0]ck| cum |[ck]u*nt|dild[a-z]*|f\\s*u\\s*c*\\s*k|fai*g"
        char <- gsub(reg, " <badword> ", char)
        char <- gsub("^\\s+|\\s+$", "", char)
        char <- gsub("\\s+", " ", char)
        char <- paste("<s>", char)
    }
    last_three_words <- tail(strsplit(tolower(char), split=" ")[[1]], 3)
    first_two_chars_last_word <- substr(tail(last_three_words, 1), 1, 2)
    
    # getting top predictions
    res <- character(0)
    to_prediction <- paste(last_three_words, collapse=" ")
    if (length(last_three_words) == 3) {
        # try 4-gram
        two_chars <- substr(to_prediction, 1, 2)
        start_stop <- hash$fourgram[[two_chars]]
        indexes <- grep(paste0("^", to_prediction, " "), 
                        names(model$fourgram[start_stop[1]:start_stop[2]]))
        if (length(indexes) != 0) {
            res <- c(res, head(sort(model$fourgram[start_stop[1]:start_stop[2]][indexes],
                                    decreasing=TRUE), 15))
        }
    }
    if (length(last_three_words) >= 2) {
        # try 3-gram
        to_prediction <- paste(tail(last_three_words, 2), collapse=" ")
        two_chars <- substr(to_prediction, 1, 2)
        start_stop <- hash$threegram[[two_chars]]
        indexes <- grep(paste0("^", paste(to_prediction, collapse=" "), " "), 
                        names(model$threegram[start_stop[1]:start_stop[2]]))
        if (length(indexes) != 0) {
            res <- c(res, head(sort(model$threegram[start_stop[1]:start_stop[2]][indexes],
                                    decreasing=TRUE), 15))
        }
    }
    # try 2-gram
    to_prediction <- paste(tail(last_three_words, 1), collapse=" ")
    two_chars <- substr(to_prediction, 1, 2)
    if (nchar(two_chars) != 2) {
        two_chars <- paste0(two_chars, " ")
    }
    start_stop <- hash$bigram[[two_chars]]
    indexes <- grep(paste0("^", to_prediction, " "), names(model$bigram[start_stop[1]:start_stop[2]]))
    if (length(indexes) != 0) {
        res <- c(res, head(sort(model$bigram[start_stop[1]:start_stop[2]][indexes], 
                                decreasing=TRUE), 15)) 
    }
    
    # processing output
    res <- names(res)
    res <- sapply(res, function(x) tail(strsplit(x, split=" ")[[1]], 1))
    res <- res[!res %in% c("<digit>", "<badword>", "<e-mail>")]
    if (status) {
        res <- res[!res %in% c("?", "!", ",", ".")]
    } else {
        if (nchar(initial) > 0) {
            res[!res %in% c("?", "!", ",", ".")] <- paste0(" ", res[!res %in% c("?", 
                                                                                "!", 
                                                                                ",", 
                                                                                ".")])
        }
        start_stop <- uni_hash[[first_two_chars_last_word]] # for App only
        if (!tail(last_three_words, 1) %in% names(unigram[start_stop[1]:start_stop[2]])) {
            ind <- grep(paste0("^", tail(last_three_words, 1)),
                        names(unigram[start_stop[1]:start_stop[2]]))
            res <- unigram[start_stop[1]:start_stop[2]][ind]
            res <- head(names(sort(res, decreasing=TRUE)), 5)
            res <- gsub(tail(last_three_words, 1), "", res)
        }
    }
    res <- unique(unname(head(res, 5)))
    ind <- logical(0)
    for (item in res) {
        word_chars <- strsplit(item, split="")
        ind <- c(ind, all(sapply(word_chars, 
                                 function(x) x %in% c(letters, "?", "!", ",", ".", " "))))
    }
    res <- res[ind]
    res <- gsub("^i$", "I", res)
    res <- gsub("^ i$", " I", res)
    return(res)
}

# helper function
predict <- function(txt, src) {
    if (src == 1) {
        return(predictNextWord(txt, model_twitter, hash_twitter, gram1_twitter, 
                               uni_hash_twitter))
    } else if (src == 2) {
        return(predictNextWord(txt, model_blogs, hash_blogs, gram1_blogs, 
                               uni_hash_blogs))
    } else if (src == 3) {
        return(predictNextWord(txt, model_news, hash_news, gram1_news, 
                               uni_hash_news))
    } else {
        return(predictNextWord(txt, model_twitter, hash_twitter, gram1_twitter, 
                               uni_hash_twitter))
    }
}

shinyServer(
    function(input, output, clientData, session) {
        prediction <- reactive({pred <- predict(input$txt, as.numeric(input$src))})
        output$preds <- renderText({paste(prediction(), collapse="         ")})
        output$txt <- renderText({paste0(input$txt, ifelse(is.na(prediction()[1]), 
                                                           "", prediction()[1]))})
    }
)
