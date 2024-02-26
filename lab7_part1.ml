(*
                              CS51 Lab 7
                   Modules and Abstract Data Types
 *)

(*
                               SOLUTION
 *)

(* Objective: This lab practices concepts of modules, including files
as modules, signatures, and polymorphic abstract data types.

There are 4 total parts to this lab. Please refer to the following
files to complete all exercises:

-> lab7_part1.ml -- Part 1: Implementing modules (this file)
   lab7_part2.ml -- Part 2: Files as modules
   lab7_part3.ml -- Part 3: Interfaces as abstraction barriers
   lab7_part4.ml -- Part 4: Polymorphic abstract types
 *)

(*======================================================================
Part 1: Implementing Modules

*Modules* are a way to package together and encapsulate types and values
(including functions) into a single discrete unit.

By applying a *signature* to a module, we guarante that the module
implements at least the values and functions defined within it. The
module may also implement more as well, for internal use, but only those
specified in the signature will be exposed and available outside the
module definition. This form of abstraction, information hiding,
implements the edict of compartmentalization.

Below is a `MATH` signature; we'll use it to describe a limited subset
of functions and values that a mathematics module might contain.
......................................................................*)

module type MATH =
  sig
    (* the constant pi *)
    val pi : float
    (* cosine of an angle in radians *)
    val cos : float -> float
    (* sine of an angle in radians *)
    val sin : float -> float
    (* sum of two numbers *)
    val sum : float -> float -> float
    (* maximum value in a list; None if list is empty *)
    val max_opt : float list -> float option
  end ;;

(*......................................................................
Exercise 1A: Complete the implementation of a module called `Math`
that satisfies the signature above. Feel free to make use of various
functions in the `Stdlib` module
<https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html>. *)
(*....................................................................*)

(* Most of the pertinent math functions are already available in the
`Stdlib` module
<https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html>.
We can just use them here. And since functions are first-class values
in OCaml, you don't need to replicate the argument structure in the
definitions. For example, there's no need for

    let cos x = Stdlib.cos x     .

We can simply specify

    let cos = Stdlib.cos

or, because the Stdlib module is always pre-opened,

    let cos = cos     .

The only function not already available is `max_opt`; we generated a
simple implementation using a partially applied fold on non-empty lists.
Within `max_opt`, we call `List.fold_left` on the `max` function from
the `Stdlib` module to update the accumulator each time a value in the
list is greater than the previous maximum value. *)

module Math : MATH =
  struct
    let pi = 3.14159
    let cos = cos
    let sin = sin
    let sum = (+.)
    let max_opt lst =
      match lst with
      | [] -> None
      | hd :: tl -> Some (List.fold_left max hd tl)
  end ;;

(*......................................................................
Exercise 1B: Now that you've implemented the `Math` module, use it to
compute the maximum of the cosine of pi and the sine of pi, a value of
type float option. Name the resulting value `result`. (Use explicit
module prefixes for this exercise, not global or local opens.)
......................................................................*)

let result = Math.max_opt [Math.cos Math.pi; Math.sin Math.pi] ;;

(*......................................................................
Exercise 1C: Reimplement the computation from 1B above, now as
`result_local_open`, but using a local open to write your computation
in a more succinct manner.
......................................................................*)

let result_local_open =
  let open Math in
  max_opt [cos pi; sin pi] ;;

(* Isn't the version with the local open more readable?! *)
