--
-- Mark Karpov's personal blog.
--
-- Copyright © 2015–2017 Mark Karpov

{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Hakyll
import Text.Pandoc.Options

feedConfig :: FeedConfiguration
feedConfig = FeedConfiguration
  { feedTitle       = "Mark Karpov's Blog"
  , feedDescription = "Random programming stuff, mainly Haskell and Emacs"
  , feedAuthorName  = "Mark Karpov"
  , feedAuthorEmail = "markkarpov@opmbx.org"
  , feedRoot        = "https://mrkkrp.github.io"
  }

pandocCompiler' :: Compiler (Item String)
pandocCompiler' = pandocCompilerWith readerOpts writerOpts
  where
    readerOpts = defaultHakyllReaderOptions
    writerOpts = defaultHakyllWriterOptions { writerHTMLMathMethod = MathJax "" }

main :: IO ()
main = hakyll $ do

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "js/*" $ do
    route idRoute
    compile copyFileCompiler

  match "img/*" $ do
    route idRoute
    compile copyFileCompiler

  match "posts/*" $ do
    route $ setExtension "html"
    compile $ pandocCompiler'
      >>= loadAndApplyTemplate "templates/post.html" datedContext
      >>= loadAndApplyTemplate "templates/default.html"  datedContext
      >>= relativizeUrls

  create ["index.html"] $ do
    route idRoute
    compile $ do
      ts <- recentFirst =<< loadAll "posts/*"
      let tutorialsContext =
            listField "posts" datedContext (return ts) <>
            constField "title" "Index" <>
            defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/index.html" tutorialsContext
        >>= loadAndApplyTemplate "templates/default.html" tutorialsContext
        >>= relativizeUrls

  match "contact.md" $ do
    route $ setExtension "html"
    compile $ pandocCompiler'
      >>= loadAndApplyTemplate "templates/default.html" datedContext
      >>= relativizeUrls

  create ["feed.atom"] $ do
    route idRoute
    compile $ do
      posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
      renderAtom feedConfig datedContext posts

  match "templates/*" $ compile templateCompiler

datedContext :: Context String
datedContext = dateField "date" "%B %e, %Y" <> defaultContext
