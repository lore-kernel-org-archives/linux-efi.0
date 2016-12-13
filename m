From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] efi: efi_print_memmap(): Call out invalid entries in
 the memory map early.
Date: Tue, 13 Dec 2016 10:09:47 -0500
Message-ID: <20161213150946.2uwupnebehhahnx7@redhat.com>
References: <20161207213830.15984-1-pjones@redhat.com>
 <CAKv+Gu9Qs=bEee_Ks6ycsVEyb_W4bFB5YzGYXPXAm5f7QrtDNQ@mail.gmail.com>
 <20161212234030.3mu4bv5bjm5ysz2d@redhat.com>
 <CAKv+Gu9iGOsytENrEvOsHx81exxexbS_NdtTmL3WOsQr6B4_9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9iGOsytENrEvOsHx81exxexbS_NdtTmL3WOsQr6B4_9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 13, 2016 at 09:19:26AM +0000, Ard Biesheuvel wrote:
> 
> > Though given the first patch, it's not clear that the second or fourth
> > one are really needed any more.  They'd only protect against bad entries
> > we've added ourselves.  But I've left them intact until we've discussed
> > this further.
> >
> > One question - we should probably be doing this on non-x86 as well.
> > What's the best way to do that?
> >
> 
> I don't think there is any point to going out of our way to recheck
> for bogus entries if we've already removed them from our copy of the
> memory map.

Yeah, that sounds reasonable enough.  We probably should still do the
third patch in the series, btw.  I wrote that one before I realized
these were 0-page maps instead of U64_MAX-page maps, and the end
calculations underrun if the num_pages value is 0.  So the result was
that the 0-page entries all had U64_MAX sizes (and thus spanned all of
memory), but I think it's still relevant even once we've made those
entries not exist.

AFAICS if there's ever a second entry that matches the same address
efi_memmap_insert() will split more times than efi_memmap_split_count()
indicates, and that's clearly not as intended.  And I can easily believe
in a situation where some misguided firmware vendor has a call that says
RegisterConfigurationTable(addr, size) that creates a new
EfiRuntimeServicesData memory map entry, but refuses to split up an
entry that's EfiACPIMemoryNVS when they call it on ACPI table data.
It's just too easy to get wrong.

I'm also really thinking the three big clauses in efi_memmap_insert()
should have an "else" stuck between each of them, since the case of
split_count=3 is clearly the middle one, and it's not supposed to
reflect that the first and third case might each fire.   But since the
bug can trigger over multiple entries, and we have to walk the whole
table each time, we need to ensure it will only trigger once across the
whole run.

And, you know, it's not like any of us believe we won't see more memory
maps with errors in the future.

> As far as ARM/arm64 are concerned: we are still in normative mode, and
> firmware that breaks booting on Linux is unlikely to ship. Instead, we
> should probably push for a clarification in the spec that the memory
> map should not contain entries with a zero page count. (Other bogus
> entries are already banned implicitly since they cannot accurately
> reflect reality)

Fair enough regarding ARM - must be nice ;)  I'll write up an ECR for
USWG to handle the rest of the world.  I'm going to add language to
explicitly ban the impossible values as well - belt and suspenders, etc.
It should be pretty straightforward.

Thanks!

-- 
  Peter
