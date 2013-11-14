(* -*- coding: utf-8-unix -*- *)

(** * category theory 

  In this library we introduce the category theory needed for K-theory:

  - products, coproducts, direct sums, finite direct sums
  - additive categories, matrices
  - exact categories

  Using Qed, we make all proof irrelevant proofs opaque. *)

Require Import RezkCompletion.precategories.
Import RezkCompletion.pathnotations.PathNotations.
Import Foundations.hlevel2.hSet.

Add LoadPath "." as Ktheory.
Require Import Ktheory.Utilities.

Local Notation "b ← a" := (precategory_morphisms a b) (at level 50).
Local Notation "a → b" := (precategory_morphisms a b) (at level 50).
Local Notation "f ;; g" := (precategories.compose f g) (at level 50).
Local Notation "g ∘ f" := (precategories.compose f g) (at level 50).

Definition assoc' (C : precategory) : 
   forall (a b c d : C) 
          (f : a → b)(g : b → c) (h : c → d),
                     h ∘ (g ∘ f) == (h ∘ g) ∘ f.
Proof. intros. apply pathReversal. apply assoc. Qed.

Unset Automatic Introduction.

Definition isiso {C:precategory} {a b:C} (f : a → b) := total2 (is_inverse_in_precat f).

(** ** products *)

Module Products.

  (** *** terminal objects *)

  Definition isTerminalObject {C:precategory} (a:C) := forall (x:C), iscontr (a ← x).

  Lemma isaprop_isTerminalObject {C:precategory} (a:C) : isaprop(isTerminalObject a).
  Proof. prop_logic. Qed.

  Definition isTerminalObjectProp {C:precategory} (a:C) := 
    hProppair (isTerminalObject a) (isaprop_isTerminalObject a) : hProp.

  Definition TerminalObject (C:precategory) := total2 (fun a:C => isTerminalObject a).

  Definition squashTerminalObject (C:precategory) := squash (TerminalObject C).

  Definition squashTerminalObjectProp (C:precategory) := 
    hProppair (squashTerminalObject C) (isaprop_squash _).

  (** *** binary products *)

  Definition isBinaryProduct {C:precategory} {a b p : C} (f : p → a) (g : p → b) :=
    forall p' (f' : p' → a) (g' : p' → b),
      iscontr ( total2 ( fun h => dirprod (f ∘ h == f') (g ∘ h == g'))).

  Lemma isaprop_isBinaryProduct {C:precategory} {a b p : C} (f : p → a) (g : p → b) : isaprop(isBinaryProduct f g).
  Proof. prop_logic. Qed.

  Definition isBinaryProductProp {C:precategory} {a b p : C} (f : p → a) (g : p → b) :=
    hProppair (isBinaryProduct f g) (isaprop_isBinaryProduct _ _).

  Definition BinaryProduct {C:precategory} (a b : C) := 
    total2 (fun p => 
    total2 (fun f : p → a => 
    total2 (fun g : p → b => 
                    isBinaryProduct f g))).

  Definition squashBinaryProducts (C:precategory) := forall a b : C, squash (BinaryProduct a b).

  Lemma isaprop_squashBinaryProducts (C:precategory) : isaprop (squashBinaryProducts C).
  Proof. prop_logic. Qed.

  Definition squashBinaryProductsProp (C:precategory) := 
    hProppair (squashBinaryProducts C) (isaprop_squashBinaryProducts _).

End Products.

(** ** coproducts *)

Module Coproducts.

  (** This module is obtained from the module Products by copying and then reversing arrows from → to ←,
   reversing composition from ∘ to ;;, and changing various words. *)

  (** *** initial objects *)

  Definition isInitialObject {C:precategory} (a:C) := forall (x:C), iscontr (a → x).

  Lemma initialObjectIsomorphy {C:precategory} (a b : C) : isInitialObject a -> isInitialObject b -> iso a b.
  Proof.
    intros ? ? ?.
    intros map_from_a_to map_from_b_to. 
    exists (the (map_from_a_to b)). 
    exists (the (map_from_b_to a)).
    split. 
      intermediate (the (map_from_a_to a)). 
        apply uniqueness.
      apply uniqueness'. 
    intermediate (the (map_from_b_to b)). 
      apply uniqueness.
    apply uniqueness'.
  Defined.

  Lemma isaprop_isInitialObject {C:precategory} (a:C) : isaprop(isInitialObject a).
  Proof. prop_logic. Qed.

  Definition isInitialObjectProp {C:precategory} (a:C) := 
    hProppair (isInitialObject a) (isaprop_isInitialObject a) : hProp.

  Definition InitialObject (C:precategory) := total2 (fun a:C => isInitialObject a).

  Definition squashInitialObject (C:precategory) := squash (InitialObject C).

  Definition squashInitialObjectProp (C:precategory) := 
    hProppair (squashInitialObject C) (isaprop_squash _).

  (** *** binary coproducts *)

  Definition isBinaryCoproduct {C:precategory} {a b p : C} (f : p ← a) (g : p ← b) :=
    forall p' (f' : p' ← a) (g' : p' ← b),
      iscontr ( total2 ( fun h => dirprod (f ;; h == f') (g ;; h == g'))).

  Lemma isaprop_isBinaryCoproduct {C:precategory} {a b p : C} (f : p ← a) (g : p ← b) : isaprop(isBinaryCoproduct f g).
  Proof. prop_logic. Qed.

  Definition isBinaryCoproductProp {C:precategory} {a b p : C} (f : p ← a) (g : p ← b) :=
    hProppair (isBinaryCoproduct f g) (isaprop_isBinaryCoproduct _ _).

  Definition BinaryCoproduct {C:precategory} (a b : C) := 
    total2 (fun p => 
    total2 (fun f : p ← a => 
    total2 (fun g : p ← b => 
          isBinaryCoproduct f g))).

  Definition squashBinaryCoproducts (C:precategory) := forall a b : C, squash (BinaryCoproduct a b).

  Lemma isaprop_squashBinaryCoproducts (C:precategory) : isaprop (squashBinaryCoproducts C).
  Proof. prop_logic. Qed.

  Definition squashBinaryCoproductsProp (C:precategory) := 
    hProppair (squashBinaryCoproducts C) (isaprop_squashBinaryCoproducts _).

End Coproducts.

Module DirectSums.

  Import Coproducts Products.

  Record ZeroObject (C:precategory) := makeZeroObject { 
      zero_object : C ; 
      map_from : isInitialObject zero_object ; 
      map_to : isTerminalObject zero_object }.
  Implicit Arguments zero_object [C].
  Implicit Arguments map_from [C].
  Implicit Arguments map_to [C].
  Coercion zero_object : ZeroObject >-> ob.

  Lemma initMapUniqueness {C:precategory} (a:ZeroObject C) (b:C) (f:a→b) : f == the (map_from a b).
  Proof. intros. exact (uniqueness (map_from a b) f). Qed.

  Lemma initMapUniqueness2 {C:precategory} (a:ZeroObject C) (b:C) (f g:a→b) : f == g.
  Proof.
   intros.
   intermediate (the (map_from a b)).
   apply initMapUniqueness.
   apply pathsinv0.
   apply initMapUniqueness.
  Qed.

  Definition hasZeroObject (C:precategory) := squash (ZeroObject C).

  Lemma zeroObjectIsomorphy {C:precategory} (a b:ZeroObject C) : iso a b.
  Proof.
    intros.
    exact (initialObjectIsomorphy a b (map_from a) (map_from b)).
  Defined.

  Definition zeroMap' {C:precategory} (o:ZeroObject C) (a b:C) := the (map_from o b) ∘ the (map_to o a) : a → b.

  Lemma path_right_composition {C:precategory} : forall (a b c:C) (g:a→b) (f f':b→c), f == f' -> f ∘ g == f' ∘ g.
  Proof. intros ? ? ? ? ? ? ? []. apply idpath. Qed.

  Lemma path_left_composition {C:precategory} : forall (a b c:C) (f:b→c) (g g':a→b), g == g' -> f ∘ g == f ∘ g'.
  Proof. intros ? ? ? ? ? ? ? []. apply idpath. Qed.

  Lemma zeroMapUniqueness {C:precategory} (x y:ZeroObject C) : forall a b:C, zeroMap' x a b == zeroMap' y a b.
  Proof.
    intros.
    set(i := the (map_to x a)).
    set(h := the (map_from x y)).
    set(q := the (map_from y b)).
    intermediate (q ∘ (h ∘ i)). 
      intermediate ((q ∘ h) ∘ i). 
        apply path_right_composition.
        apply uniqueness'.
      apply assoc. 
    apply path_left_composition.
    apply uniqueness.
  Qed.

  Corollary zeroMapsUniqueness {C:precategory} (x y:ZeroObject C) : zeroMap' x == zeroMap' y.
  (* probably will not be needed *)
  Proof.
    intros.
    apply funextsec.
    intros t.
    apply funextsec.
    apply zeroMapUniqueness.
  Defined.

  Lemma zeroMap {C:precategory} : hasZeroObject C -> forall a b:C, a → b.
  Proof.
    intros.
    generalize X. clear X.
    apply (squash_to_set _ _ (fun z => zeroMap' z a b)).
    apply isaset_hSet.    
    intros. apply zeroMapUniqueness.
  Defined.
  
  Lemma goal3 {C:precategory} (z:ZeroObject C) (a b:C) : zeroMap' z a b == zeroMap (squash_element z) a b. 
  Proof. trivial. Qed.

  Lemma zeroMap'_left_composition {C:precategory} (z:ZeroObject C) : forall (a b c:C) (f:b→c), f ∘ zeroMap' z a b == zeroMap' z a c. 
  Proof.
   intros. unfold zeroMap'.
   intermediate ((f ∘ the (map_from z b)) ∘ the (map_to z a)).
     apply assoc'.
   apply path_right_composition.
   apply initMapUniqueness.
  Qed.

  Lemma zeroMap_left_composition {C:precategory} (a b c:C) (f:b→c) (h:hasZeroObject C) : f ∘ zeroMap h a b == zeroMap h a c. 
  Proof.
    intros ? ? ? ? ?.
    apply (@factor_dep_through_squash (ZeroObject C)).
      intro. apply isaset_hSet.
    intro z.
    destruct (goal3 z a b).
    destruct (goal3 z a c).
    apply zeroMap'_left_composition.
  Qed.

  (* the following definition is not right yet *)
  Definition isBinarySum {C:precategory} {a b s : C} (p : s → a) (q : s → b) (i : a → s) (j : b → s) :=
    dirprod (isBinaryProduct p q) (isBinaryCoproduct i j).
  
  Lemma isaprop_isBinarySum {C:precategory} {a b s : C} (p : s → a) (q : s → b) (i : a → s) (j : b → s) :
    isaprop (isBinarySum p q i j).
  Proof. prop_logic. Qed.

  Record BinarySum {C:precategory} (a b : C) := makeBinarySum {
      s ;
      p : s → a ; q : s → b ;
      i : a → s ; j : b → s ;
      is : isBinarySum p q i j
      }.

  Definition squashBinarySums (C:precategory) :=
    forall a b : C, squash (BinarySum a b).

(**

  We are working toward definitions of "additive category" and "abelian
  category" as properties of a category, rather than as an added structure.
  That is the approach of Mac Lane in sections 18, 19, and 21 of :

  Duality for groups
  Bull. Amer. Math. Soc. Volume 56, Number 6 (1950), 485-516.
  http://projecteuclid.org/DPubS/Repository/1.0/Disseminate?view=body&id=pdf_1&handle=euclid.bams/1183515045

 *)

End DirectSums.

