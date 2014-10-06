From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Mon, 6 Oct 2014 15:33:43 -0400
Message-ID: <20141006193342.GC9811@fenchurch.internal.datastacks.com>
References: <1405421886-11692-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405522297.25580.72.camel@deneb.redhat.com>
 <20140716155345.GB30313@leverpostej>
 <1405539927.25580.74.camel@deneb.redhat.com>
 <CAKv+Gu-bqXKoy-G00cWPJES=6A_ofu=cfBOsD0ZriHa4AGxG0A@mail.gmail.com>
 <1405544636.25580.83.camel@deneb.redhat.com>
 <CAKv+Gu8kvU8ndeG2vF5HqRhjK+_F=8D52eabHzy++nTHt_pAYQ@mail.gmail.com>
 <1405606141.25580.108.camel@deneb.redhat.com>
 <CAKv+Gu9N4PB3BQ3_HOoaFopkugbWJujEAb419HAULcjujtX1Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9N4PB3BQ3_HOoaFopkugbWJujEAb419HAULcjujtX1Uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 06, 2014 at 08:13:01PM +0200, Ard Biesheuvel wrote:
> On 17 July 2014 16:09, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 2014-07-16 at 23:13 +0200, Ard Biesheuvel wrote:
> >> On 16 July 2014 23:03, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > On Wed, 2014-07-16 at 22:38 +0200, Ard Biesheuvel wrote:
> >> >> On 16 July 2014 21:45, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> >> > On Wed, 2014-07-16 at 16:53 +0100, Mark Rutland wrote:
> >> >> >> On Wed, Jul 16, 2014 at 03:51:37PM +0100, Mark Salter wrote:
> >> >> >> > On Tue, 2014-07-15 at 12:58 +0200, Ard Biesheuvel wrote:
> >> >> >> > > After the EFI stub has done its business, it jumps into the kernel by branching
> >> >> >> > > to offset #0 of the loaded Image, which is where it expects to find the header
> >> >> >> > > containing a 'branch to stext' instruction.
> >> >> >> > >
> >> >> >> > > However, the header is not covered by any PE/COFF section, so the header may
> >> >> >> > > not actually be loaded at the expected offset. So instead, jump to 'stext'
> >> >> >> > > directly, which is at the base of the PE/COFF .text section, by supplying a
> >> >> >> > > symbol 'stext_offset' to efi-entry.o which contains the relative offset of
> >> >> >> > > stext into the Image. Also replace other open coded calculations of the same
> >> >> >> > > value with a reference to 'stext_offset'
> >> >> >> >
> >> >> >> > Have you actually seen a situation where the header isn't there?
> >> >> >> > Isn't the kernel header actually part of the pe/coff file and
> >> >> >> > firmware loads the whole file into RAM?
> >> >> >>
> >> >> >> From my understanding of Ard's earlier comments, this part isn't
> >> >> >> guaranteed per the UEFI spec.
> >> >> >>
> >> >> >> I would rather we weren't relying on implementation details.
> >> >> >>
> >> >> >
> >> >> > Could be. I didn't see anything about it in the UEFI spec, but I
> >> >> > probably wasn't exhaustive in my search. In any case, there's at
> >> >> > least one other place broken if the kernel header isn't included
> >> >> > in the loaded image.
> >> >> >
> >> >>
> >> >> I have not been able to find anything in the PE/COFF documents that
> >> >> tells you what to put in memory areas that are not covered by a
> >> >> section. Expecting the header to be there is indeed relying on an
> >> >> implementation detail, which seems risky.
> >> >> And indeed, if there are any other (non EFI related) uses of header
> >> >> fields in the kernel, it would be good to have a look at those well,
> >> >
> >> > I think we need to come up with a loader which does load an image
> >> > without kernel header so that we can test. Otherwise, we'll probably
> >> > end up with buggy code anyway. The stub code assumes the the loaded
> >> > image pointed to by the system table is the whole image. Seems like
> >> > we'd need to add code to determine if it is whole kernel image or
> >> > image without initial header. Stub would have to handle both cases.
> >> > For instance, one case would want image placed at 2MiB+TEXT_OFFSET,
> >> > other case would want 2MiB+TEXT_OFFSET+sizeof(kernel header).
> >> >
> >>
> >> No, this has nothing to do with misaligned data.
> >>
> >> The PE/COFF .text section does not start at virtual offset #0 but at
> >> virtual offset 'stext - efi_head'.
> >> In other words, there is a hole in the virtual image where the header
> >> is supposed to be.
> >> So if there is no PE/COFF section describing what data should be put
> >> at offset #0 by the loader, we can't assume the header is there, even
> >> if ImageBase does start at #0
> >
> > I get that. You're supposing UEFI will always allocate memory for the
> > full image, but only sometimes copy the PE/COFF headers. I can see your
> > point from a PE/COFF perspective, but not so much from the UEFI spec
> > perspective where the language leads me to think it treats the PE/COFF
> > images as one unit wrt loading. In any case, it really isn't worth
> > arguing about. I don't have any objection to the patch since it won't
> > break anything from my perspective and it'll protect against breakage
> > which could possibly occur with some firmware implementations.
> >
> 
> I am reviving this old thread because it appears we may have seen an
> issue involving shim and GRUB where data not covered by any loadable
> PE/COFF section was not actually loaded to memory. In this case, it
> was the ".reloc" section, not the header but the conclusion should be
> the same.
> 
> @Peter: this is a second-hand account so perhaps you could fill in
> with some details? Original thread is here:
> http://marc.info/?l=linux-arm-kernel&m=140542202520933&w=2

So what happened with the shim+grub .reloc problem was that grub's
binary has relocations (which I think don't strictly need to be
processed), but shim's relocation code was *completely* defective.

Then I fixed shim to try to process relocations, but got it wrong
because in my mind data directories were file addresses rather than
relative virtual addresses (often they are identical, but by spec
they're RVAs). In grub's binary, everything has matching file addresses
and RVAs.  So grub worked, but other things did not.  That change is
here:

https://github.com/mjg59/shim/commit/a846aedd0e9dfe26ca6afaf6a1db8a54c20363c1

Then I realized that they are always RVAs and we have to match the base
relocation data directory up with the .reloc section for processing.  So
in the current code we /do/ load .reloc into memory to process the
relocations if we find the section there, but we don't mirror it into
the final image we've relocated and are executing if it's marked
discardable, which it typically is.

That change is here:

https://github.com/mjg59/shim/commit/a846aedd0e9dfe26ca6afaf6a1db8a54c20363c1

And it seems to work with all the binaries we actually generate,
including grub, MokManager.efi, fallback.efi, etc.

Just in general, though, I don't see that there's any PE spec
requirement that we have to copy anything from the binary into the
address range we're going to jump in to unless all of the following are
true:

1) it is covered by a section header
2) the section is non-discardable
3) the section's SizeOfRawData is nonzero
4) basic constraints of sanity are met - i.e. the section data is
   actually entirely within the binary, it's doesn't overlap with the
   data directory or the PE headers, etc.

There is the obvious case where something should exist in your running
copy that is not not covered by the above - .bss and such.  But those
are not /copied/ from the binary.

So is there a question now?

-- 
        Peter
