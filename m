From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Sat, 14 Mar 2015 08:53:57 +0100
Message-ID: <20150314075357.GA8319@gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
 <20150313122756.GA28855@gmail.com>
 <CAE9FiQXaRmJFdEUhyn2q0v=9ymdbqZWEo1pzo6iyaNupWEp5Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQXaRmJFdEUhyn2q0v=9ymdbqZWEo1pzo6iyaNupWEp5Xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Fri, Mar 13, 2015 at 5:27 AM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > * Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> >> commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping 
> >> initrd") introduced one run_size for kaslr. We should use real 
> >> runtime size (include copy/decompress) aka init_size.
> >
> > Why, what happens if we don't change this?
> 
> While trying to update change log, found we still need to keep this 
> run_size. otherwise kaslr will find not needed big size of init_size 
> instead of max(output_len, run_size).

You are still talking only about the low level code and about low 
level symptoms, while in contrast to that the primary question with 
_any_ change to the kernel is always:

   WHY ARE WE CHANGING THE KERNEL, WHAT BAD HIGH LEVEL BEHAVIOR CAN A 
   USER OBSERVE IF THE BUG IS NOT FIXED?

Your descriptions totally ignore the high level effects of the bug on 
the system and on users of the machine, and you fail to describe them 
properly. You totally concentrate on the low level: your descriptions 
are missing the forest from all the trees.

That makes 90% of your patch descriptions useless.

In fact, 90% of your patches had that deficiency and had it for the 
past 4 years, non-stop, and maintainers were complaining to you about 
that, non-stop as well. Do you think maintainers enjoy complaining 
about deficiencies? Do you wonder why maintainers were forced to 
simply stop looking at any complex series from yours after you refused 
to change?

> will refresh the patchset.

So let me try this again, one very last time.

That sentence demonstrates your problem: it's not a 'refresh' your 
patches need, but a 'hard reboot', a totally new viewpoint that 
concentrates on what matters: that zooms out of the small details of 
the patch!

For any serious change to the Linux kernel, analyzing small details is 
fine and required as well, AFTER the high level has been discussed 
properly:

  - What happened, what high level concern motivates you to change the 
    Linux kernel?

       And no, starting a changelog with:

          commit e6023367d779 ("x86, kaslr: Prevent .bss from 
          overlaping initrd") introduced one run_size for kaslr.

       is not 'high level' in any way, it talks about code in the 
       first sentence! Talking about code, not talking about high 
       level concerns is a BUG().

  - What was the previous (often bad) high level behavior of the
    kernel?

       And no, 'KASLR will not find a proper area' is NOT a high level
       description, it's a very low level description! Not discussing 
       high level behavior of the kernel in a changelog is a BUG().

  - What new high level behavior do we want to happen instead?

       And no, saying that 'KASLR should be passed init_size instead
       of run_size' is not a description of desired new high level
       behavior! Not discussing the desired high level behavior of the 
       kernel in a changelog is a BUG().

  - What was the high level design of the old code, was that design
    fine, should it be changed, and if yes, in what way?

       Note that we describe the high level design even if we don't
       change it, partly to give context to the reader, partly to 
       prove that you know what you are doing, to build trust in your 
       patch! Not discussing the old (and new) design of that area of 
       the kernel is a BUG().

and only then do we:

  - Describe the old implementation, and describe how the new
    implementation works in all that context.

       Here is where 99.9% of your existing changelogs fit in.
       Put differently: your changelogs are missing the first 3 
       essential components of a changelog.

       And note, mentioning 'run_size' in a low level description is 
       fine. Mentioning it in a high level description is a BUG(): 
       that is why Boris was trying to change your changelogs into 
       spoken English, to recover some of that missing high level 
       context. Maintainers like Boris should not be forced to do 
       that, you are supposed to offer this with any significant 
       patch, as a passport to prove that your changes to the code are 
       worth looking at.

And yes, we do it in that order. Take a look at a recent single line 
change Linus made in 53da3bc2ba9e48, attached to this mail.

Check how the changelog is structured: it discusses high level 
concepts first. It's a _ONE LINER FIX_ from Linus, yet it's spread 
over 8 paragraphs and 50 lines, because the change justified that kind 
of description.

And observe the moment when Linus, in his 8 paragraphs, 50 lines 
description starts talking about low level implementational details, 
when he mentions lines of code, function names, such as 
do_numa_page(), 'pte_write()' or 'pte_dirty()'.

He doesnt!

It's not needed for a one-liner most of the time: but the high level 
concepts around that code are very much necessary to convey.

Now contrast that with your changelogs: your changelogs are stock full 
of non-English phrases resembling code more than a fluid description, 
they are stock full of low level details, mentioning of function 
names, variables and fields with no high level context conveyed 
whatsoever.

Let me try to put it to you in a way that might come across: when I 
run maintainer code over your changelogs it runs into an instant BUG() 
most of the time, forcing me to drop your patches.

High level discussion of old behavior, new behavior, old design and 
new design isn't just some detail to be slapped on a change after the 
fact, this is a serious and required technological aspect of the Linux 
kernel, and 90% of your patches are buggy in that respect.

In fact, I noticed that both your descriptions and your followups to 
them are totally lacking the high level viewpoint!

Either you:

   - refuse to think in high level concepts when you are writing 
     patches, in which case we need to keep your patches away from
     the Linux kernel,

   - or you are unwilling to document such high level thinking 
     processes, in which case we need to keep your patches away from 
     the Linux kernel as well.

If your appoach to writing kernel patches does not change then I will 
be forced to take action, currently you are this -->.<-- close to 
being filtered out from my default inbox for your total refusal to 
change the technology of how you are writing patches.

Thanks,

	Ingo

[ Sample 'good' changelog from Linus: ]

======================>
>From 53da3bc2ba9e4899f32707b5cd7d18421b943687 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Date: Thu, 12 Mar 2015 08:45:46 -0700
Subject: [PATCH] mm: fix up numa read-only thread grouping logic

Dave Chinner reported that commit 4d9424669946 ("mm: convert
p[te|md]_mknonnuma and remaining page table manipulations") slowed down
his xfsrepair test enormously.  In particular, it was using more system
time due to extra TLB flushing.

The ultimate reason turns out to be how the change to use the regular
page table accessor functions broke the NUMA grouping logic.  The old
special mknuma/mknonnuma code accessed the page table present bit and
the magic NUMA bit directly, while the new code just changes the page
protections using PROT_NONE and the regular vma protections.

That sounds equivalent, and from a fault standpoint it really is, but a
subtle side effect is that the *other* protection bits of the page table
entries also change.  And the code to decide how to group the NUMA
entries together used the writable bit to decide whether a particular
page was likely to be shared read-only or not.

And with the change to make the NUMA handling use the regular permission
setting functions, that writable bit was basically always cleared for
private mappings due to COW.  So even if the page actually ends up being
written to in the end, the NUMA balancing would act as if it was always
shared RO.

This code is a heuristic anyway, so the fix - at least for now - is to
instead check whether the page is dirty rather than writable.  The bit
doesn't change with protection changes.

NOTE! This also adds a FIXME comment to revisit this issue,

Not only should we probably re-visit the whole "is this a shared
read-only page" heuristic (we might want to take the vma permissions
into account and base this more on those than the per-page ones, and
also look at whether the particular access that triggers it is a write
or not), but the whole COW issue shows that we should think about the
NUMA fault handling some more.

For example, maybe we should do the early-COW thing that a regular fault
does.  Or maybe we should accept that while using the same bits as
PROTNONE was a good thing (and got rid of the specual NUMA bit), we
might still want to just preseve the other protection bits across NUMA
faulting.

Those are bigger questions, left for later.  This just fixes up the
heuristic so that it at least approximates working again.  More analysis
and work needed.

Reported-by: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Tested-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 mm/memory.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8068893697bb..411144f977b1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3072,8 +3072,13 @@ static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * Avoid grouping on DSO/COW pages in specific and RO pages
 	 * in general, RO pages shouldn't hurt as much anyway since
 	 * they can be in shared cache state.
+	 *
+	 * FIXME! This checks "pmd_dirty()" as an approximation of
+	 * "is this a read-only page", since checking "pmd_write()"
+	 * is even more broken. We haven't actually turned this into
+	 * a writable page, so pmd_write() will always be false.
 	 */
-	if (!pte_write(pte))
+	if (!pte_dirty(pte))
 		flags |= TNF_NO_GROUP;
 
 	/*
