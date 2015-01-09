From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi: stub: call get_memory_map() to obtain map and desc
 sizes
Date: Fri, 9 Jan 2015 10:19:50 +0000
Message-ID: <20150109101950.GA27421@leverpostej>
References: <1420739507-1708-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150108190426.GC31280@leverpostej>
 <CAKv+Gu9tVjfU5S=3oLTznUFnv0WAbGcKueNjKtDtYqGQ+cxtxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9tVjfU5S=3oLTznUFnv0WAbGcKueNjKtDtYqGQ+cxtxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 08, 2015 at 07:09:22PM +0000, Ard Biesheuvel wrote:
> On 8 January 2015 at 19:04, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > Hi Ard,
> >
> > On Thu, Jan 08, 2015 at 05:51:47PM +0000, Ard Biesheuvel wrote:
> >> This fixes two minor issues in the implementation of get_memory_map():
> >> - Currently, it assumes that sizeof(efi_memory_desc_t) == desc_size,
> >>   which is usually true, but not mandated by the spec. (This was added
> >>   intentionally to allow future additions to the definition of
> >>   efi_memory_desc_t). The way the loop is implemented currently, the
> >>   added slack space may be insufficient if desc_size is larger, which in
> >>   some corner cases could result in the loop never terminating.
> >> - It allocates 32 efi_memory_desc_t entries first (again, using the size
> >>   of the struct instead of desc_size), and frees and reallocates if it
> >>   turns out to be insufficient. Few implementations of UEFI have such small
> >>   memory maps, which results in a unnecessary allocate/free pair on each
> >>   invocation.
> >>
> >> Fix this by calling the get_memory_map() boot service first with a '0'
> >> input value for map size to retrieve the map size and desc size from the
> >> firmware and only then perform the allocation, using desc_size rather
> >> than sizeof(efi_memory_desc_t).
> >
> > Is the desc_size guaranteed to be set up correctly if the size is too
> > small?
> >
> > As far as I can see, for that case the spec only mandates that
> > MemoryMapSize is updated nd EFI_BUFFER_TOO_SMALL is returned.
> >
> > It's not clear to me whether DescriptorSize or DescriptorVersion are
> > initialised in cases other than success.
> >
> 
> The way I read it, descriptor size and descriptor version are always
> returned, e.g., as opposed to MapKey, which is only returned on
> success, and the spec mentions that specifically.

I agree that that would be the sensible reading of the spec. I just fear
that there's room for an implementor to read it slightly differently,
and cause pain for us.

> We could ask for clarification just to be sure.

I think we should.

Given it could take a while for any conclusion to be reached and
published, I'm happy to go with the patch below in the meantime, so long
as the issue gets raised.

Cheers,
Mark.

> 
> -- 
> Ard.
> 
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>  drivers/firmware/efi/libstub/efi-stub-helper.c | 16 ++++++++++------
> >>  1 file changed, 10 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> >> index e766df60fbfb..caf91eab0bfc 100644
> >> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> >> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> >> @@ -75,25 +75,29 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
> >>       unsigned long key;
> >>       u32 desc_version;
> >>
> >> -     *map_size = sizeof(*m) * 32;
> >> -again:
> >> +     *map_size = 0;
> >> +     *desc_size = 0;
> >> +     key = 0;
> >> +     status = efi_call_early(get_memory_map, map_size, NULL,
> >> +                             &key, desc_size, &desc_version);
> >> +     if (status != EFI_BUFFER_TOO_SMALL)
> >> +             return EFI_LOAD_ERROR;
> >> +
> >>       /*
> >>        * Add an additional efi_memory_desc_t because we're doing an
> >>        * allocation which may be in a new descriptor region.
> >>        */
> >> -     *map_size += sizeof(*m);
> >> +     *map_size += *desc_size;
> >>       status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> >>                               *map_size, (void **)&m);
> >>       if (status != EFI_SUCCESS)
> >>               goto fail;
> >>
> >> -     *desc_size = 0;
> >> -     key = 0;
> >>       status = efi_call_early(get_memory_map, map_size, m,
> >>                               &key, desc_size, &desc_version);
> >>       if (status == EFI_BUFFER_TOO_SMALL) {
> >>               efi_call_early(free_pool, m);
> >> -             goto again;
> >> +             return EFI_LOAD_ERROR;
> >>       }
> >>
> >>       if (status != EFI_SUCCESS)
> >> --
> >> 1.8.3.2
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
