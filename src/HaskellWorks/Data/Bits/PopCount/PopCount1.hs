{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}

-- |
-- Copyright: 2016 John Ky
-- License: MIT
--
-- Succinct operations.
module HaskellWorks.Data.Bits.PopCount.PopCount1
    ( PopCount1(..)
    ) where

import qualified Data.Vector                    as DV
import qualified Data.Vector.Storable           as DVS
import           Data.Word
import           HaskellWorks.Data.Bits.BitWise
import           HaskellWorks.Data.Positioning
import           Prelude                        as P

class PopCount1 v where
  popCount1 :: v -> Count

instance PopCount1 Bool where
  popCount1 True  = 1
  popCount1 False = 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 Word8 where
  popCount1 x0 = Count (fromIntegral x3)
    where
      x1 = x0 - ((x0 .&. 0xaa) .>. 1)
      x2 = (x1 .&. 0x33) + ((x1 .>. 2) .&. 0x33)
      x3 = (x2 + (x2 .>. 4)) .&. 0x0f
  {-# INLINABLE popCount1 #-}

instance PopCount1 Word16 where
  popCount1 x0 = Count (fromIntegral ((x3 * 0x0101) .>. 8))
    where
      x1 = x0 - ((x0 .&. 0xaaaa) .>. 1)
      x2 = (x1 .&. 0x3333) + ((x1 .>. 2) .&. 0x3333)
      x3 = (x2 + (x2 .>. 4)) .&. 0x0f0f
  {-# INLINABLE popCount1 #-}

instance PopCount1 Word32 where
  popCount1 x0 = Count (fromIntegral ((x3 * 0x01010101) .>. 24))
    where
      x1 = x0 - ((x0 .&. 0xaaaaaaaa) .>. 1)
      x2 = (x1 .&. 0x33333333) + ((x1 .>. 2) .&. 0x33333333)
      x3 = (x2 + (x2 .>. 4)) .&. 0x0f0f0f0f
  {-# INLINABLE popCount1 #-}

instance PopCount1 Word64 where
  popCount1 x0 = Count ((x3 * 0x0101010101010101) .>. 56)
    where
      x1 = x0 - ((x0 .&. 0xaaaaaaaaaaaaaaaa) .>. 1)
      x2 = (x1 .&. 0x3333333333333333) + ((x1 .>. 2) .&. 0x3333333333333333)
      x3 = (x2 + (x2 .>. 4)) .&. 0x0f0f0f0f0f0f0f0f
  {-# INLINABLE popCount1 #-}

instance PopCount1 [Bool] where
  popCount1 = P.sum . fmap popCount1
  {-# INLINABLE popCount1 #-}

instance PopCount1 [Word8] where
  popCount1 = P.sum . fmap popCount1
  {-# INLINABLE popCount1 #-}

instance PopCount1 [Word16] where
  popCount1 = P.sum . fmap popCount1
  {-# INLINABLE popCount1 #-}

instance PopCount1 [Word32] where
  popCount1 = P.sum . fmap popCount1
  {-# INLINABLE popCount1 #-}

instance PopCount1 [Word64] where
  popCount1 = P.sum . fmap popCount1
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DV.Vector Word8) where
  popCount1 = DV.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DV.Vector Word16) where
  popCount1 = DV.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DV.Vector Word32) where
  popCount1 = DV.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DV.Vector Word64) where
  popCount1 = DV.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DVS.Vector Word8) where
  popCount1 = DVS.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DVS.Vector Word16) where
  popCount1 = DVS.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DVS.Vector Word32) where
  popCount1 = DVS.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}

instance PopCount1 (DVS.Vector Word64) where
  popCount1 = DVS.foldl (\c -> (c +) . popCount1) 0
  {-# INLINABLE popCount1 #-}