{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
{-# LANGUAGE ScopedTypeVariables #-}

module HaskellWorks.Data.Succinct.RankSelect.Binary.Basic.Select1Spec (spec) where

import           Data.Maybe
import qualified Data.Vector                                                as DV
import qualified Data.Vector.Storable                                       as DVS
import           Data.Word
import           HaskellWorks.Data.Arbitrary.Count
import           HaskellWorks.Data.Bits.BitString
import           HaskellWorks.Data.Bits.BitWise
import           HaskellWorks.Data.Bits.PopCount.PopCount1
import           HaskellWorks.Data.Succinct.RankSelect.Binary.Basic.Rank1
import           HaskellWorks.Data.Succinct.RankSelect.Binary.Basic.Select1
import           Test.Hspec
import           Test.QuickCheck

{-# ANN module ("HLint: ignore Redundant do" :: String) #-}
{-# ANN module ("HLint: ignore Reduce duplication"  :: String) #-}

spec :: Spec
spec = describe "HaskellWorks.Data.Succinct.RankSelect.InternalSpec" $ do
  describe "For [Bool]" $ do
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: [Bool] in
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 11011010 00 over [0..5]" $
      let bs = fromJust $ fromBitString "11011010 00" :: [Bool] in
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For Word8" $ do
    it "select1 10010010 over [0..3] should be 0147" $ do
      let bs = fromJust $ fromBitString "10010010" :: Word8
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
  describe "For Word64" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: Word64
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For Word64" $ do
    it "rank1 for Word16 and Word64 should give same answer for bits 0-7" $ property $
      \(Count_0_8  i) (w :: Word8 ) -> rank1 w i == rank1 (fromIntegral w :: Word64) i
    it "rank1 for Word16 and Word64 should give same answer for bits 0-15" $ property $
      \(Count_0_16 i) (w :: Word16) -> rank1 w i == rank1 (fromIntegral w :: Word64) i
    it "rank1 for Word32 and Word64 should give same answer for bits 0-31" $ property $
      \(Count_0_32 i) (w :: Word32) -> rank1 w i == rank1 (fromIntegral w :: Word64) i
    it "rank1 for Word32 and Word64 should give same answer for bits 32-64" $ property $
      \(Count_0_32 i) (v :: Word32) (w :: Word32) ->
        let v64 = fromIntegral v :: Word64 in
        let w64 = fromIntegral w :: Word64 in
        rank1 v i + popCount1 w == rank1 ((v64 .<. 32) .|. w64) (i + 32)
    it "rank1 and select1 for Word64 form a galois connection" $ property $
      \(Count_0_32 i) (w :: Word32) -> 1 <= i && i <= popCount1 w ==>
        rank1 w (select1 w i) == i && select1 w (rank1 w (fromIntegral i)) <= fromIntegral i
  describe "For [Word8]" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: [Word8]
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: [Word8]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: [Word8]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: [Word8]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For [Word16]" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: [Word16]
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: [Word16]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: [Word16]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: [Word16]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For [Word32]" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: [Word32]
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: [Word32]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: [Word32]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: [Word32]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For [Word64]" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: [Word64]
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: [Word64]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: [Word64]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: [Word64]
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For (DV.Vector Word8)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DV.Vector Word8
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DV.Vector Word8
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DV.Vector Word8
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DV.Vector Word8
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For (DV.Vector Word16)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DV.Vector Word16
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DV.Vector Word16
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DV.Vector Word16
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DV.Vector Word16
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For (DV.Vector Word32)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DV.Vector Word32
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DV.Vector Word32
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DV.Vector Word32
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DV.Vector Word32
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For (DV.Vector Word64)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DV.Vector Word64
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DV.Vector Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DV.Vector Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DV.Vector Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
  describe "For (DVS.Vector Word8)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DVS.Vector Word8
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DVS.Vector Word8
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DVS.Vector Word8
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DVS.Vector Word8
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select 01000000 00000100 over [0..2]" $ do
      let bs = fromJust $ fromBitString "01000000 00000100" :: DVS.Vector Word8
      fmap (select1 bs) [0..2] `shouldBe` [0, 2, 14]
    it "select 10000010 00000000 00100000 00010000 over [0..4]" $ do
      let bs = fromJust $ fromBitString "10000010 00000000 00100000 00010000" :: DVS.Vector Word8
      fmap (select1 bs) [0..4] `shouldBe` [0, 1, 7, 19, 28]
  describe "For (DVS.Vector Word16)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DVS.Vector Word16
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DVS.Vector Word16
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DVS.Vector Word16
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DVS.Vector Word16
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select 01000000 00000100 over [0..2]" $ do
      let bs = fromJust $ fromBitString "01000000 00000100" :: DVS.Vector Word16
      fmap (select1 bs) [0..2] `shouldBe` [0, 2, 14]
    it "select 10000010 00000000 00100000 00010000 over [0..4]" $ do
      let bs = fromJust $ fromBitString "10000010 00000000 00100000 00010000" :: DVS.Vector Word16
      fmap (select1 bs) [0..4] `shouldBe` [0, 1, 7, 19, 28]
  describe "For (DVS.Vector Word32)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DVS.Vector Word32
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DVS.Vector Word32
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DVS.Vector Word32
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DVS.Vector Word32
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select 01000000 00000100 over [0..2]" $ do
      let bs = fromJust $ fromBitString "01000000 00000100" :: DVS.Vector Word32
      fmap (select1 bs) [0..2] `shouldBe` [0, 2, 14]
    it "select 10000010 00000000 00100000 00010000 over [0..4]" $ do
      let bs = fromJust $ fromBitString "10000010 00000000 00100000 00010000" :: DVS.Vector Word32
      fmap (select1 bs) [0..4] `shouldBe` [0, 1, 7, 19, 28]
  describe "For (DVS.Vector Word64)" $ do
    it "select1 10010010 over [0..3] should be 023568" $ do
      let bs = fromJust $ fromBitString "10010010" :: DVS.Vector Word64
      fmap (select1 bs) [0..3] `shouldBe` [0, 1, 4, 7]
    it "select1 11000001 10000000 01000000 over [0..5] should be 023568" $ do
      let bs = fromJust $ fromBitString "11000001 10000000 01000000" :: DVS.Vector Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 8, 9, 18]
    it "select1 1101101000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "1101101000" :: DVS.Vector Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select1 11011010 00000000 over [0..5]" $ do
      let bs = fromJust $ fromBitString "11011010 00000000" :: DVS.Vector Word64
      fmap (select1 bs) [0..5] `shouldBe` [0, 1, 2, 4, 5, 7]
    it "select 01000000 00000100 over [0..2]" $ do
      let bs = fromJust $ fromBitString "01000000 00000100" :: DVS.Vector Word64
      fmap (select1 bs) [0..2] `shouldBe` [0, 2, 14]
    it "select 10000010 00000000 00100000 00010000 over [0..4]" $ do
      let bs = fromJust $ fromBitString "10000010 00000000 00100000 00010000" :: DVS.Vector Word64
      fmap (select1 bs) [0..4] `shouldBe` [0, 1, 7, 19, 28]
