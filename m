From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v6 2/2] efi: a misc char interface for user to update efi firmware
Date: Mon, 5 Oct 2015 12:05:47 -0700
Message-ID: <CALCETrU4+UT_2z1J+WUwnweMSuAyA0=-qoc24b2QStqUzyL3mw@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C4A864675@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A864675-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 5, 2015 at 9:07 AM, Kweh, Hock Leong
<hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org]
>> Sent: Sunday, October 04, 2015 7:16 AM
>> > +
>> > +       /* setup capsule binary info structure */
>> > +       if (cap_info.header_obtained == 0 && cap_info.index == 0) {
>> > +               efi_capsule_header_t *cap_hdr = kbuff;
>> > +               int reset_type;
>> > +               size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
>> > +                                       PAGE_SHIFT;
>> > +
>> > +               if (pages_needed == 0) {
>> > +                       pr_err("%s: pages count invalid\n", __func__);
>> > +                       kunmap(kbuff_page);
>> > +                       efi_free_all_buff_pages(kbuff_page);
>> > +                       return -EINVAL;
>> > +               }
>> > +
>> > +               /* check if the capsule binary supported */
>> > +               ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
>> > +                                           cap_hdr->imagesize,
>> > + &reset_type);
>>
>> And what if cap_hdr isn't written yet?
>
> This design mainly targeting a simplest interface that user could upload efi
> capsule in a single command action: cat capsule.bin > /dev/efi_capsule_loader
>
> So, it is expected that efi capsule header is at the starting of the binary file.
> Already capture this into efi_capsule_write() comment in v7 patchset:
> https://lkml.org/lkml/2015/10/5/232
>
> If you want to enhance this module to support creating efi capsule header for
> your binary, strongly believe this design can cater the implementation such as
> adding ioctl to pass in efi guid, flags and so on parameters to create the header.
>

No, that's not what I mean.  What I mean is: what if cat writes too
little in the first write call (e.g. 3 bytes).

>
>>
>> > +               if (ret) {
>> > +                       pr_err("%s: efi_capsule_supported() failed\n",
>> > +                              __func__);
>> > +                       kunmap(kbuff_page);
>> > +                       efi_free_all_buff_pages(kbuff_page);
>> > +                       return ret;
>> > +               }
>> > +
>> > +               cap_info.total_size = cap_hdr->imagesize;
>> > +               cap_info.pages = kmalloc_array(pages_needed, sizeof(void *),
>> > +                                               GFP_KERNEL);
>> > +               if (!cap_info.pages) {
>> > +                       pr_debug("%s: kmalloc_array() failed\n", __func__);
>> > +                       kunmap(kbuff_page);
>> > +                       efi_free_all_buff_pages(kbuff_page);
>> > +                       return -ENOMEM;
>> > +               }
>> > +
>> > +               cap_info.header_obtained = 1;
>>
>> I don't see how you know that the header is obtained.
>
> Capsule header is at the starting block of image binary. We can
> obtain the header through the 1st block of write action.

That's quite an assumption to make.

> So,
> user app is expected to upload the image binary sequentially.
>

>> > +       cap_info.pages[cap_info.index++] = kbuff_page;
>>
>> Huh?  You might now have allocated a whole page.
>
> Yes, the efi capsule header does tell the whole image size.

So what?  Did you allocate a page in this particular write call?  If
so, then cap_info.index++, etc is okay.  If not, it's wrong.

>> > +       cap_info.count += write_byte;
>> > +       kunmap(kbuff_page);
>> > +
>> > +       /* submit the full binary to efi_capsule_update() API */
>> > +       if (cap_info.count >= cap_info.total_size) {
>> > +               void *cap_hdr_temp;
>> > +
>> > +               cap_hdr_temp = kmap(cap_info.pages[0]);
>> > +               if (!cap_hdr_temp) {
>> > +                       pr_debug("%s: kmap() failed\n", __func__);
>> > +                       efi_free_all_buff_pages(NULL);
>> > +                       return -EFAULT;
>> > +               }
>> > +               ret = efi_capsule_update(cap_hdr_temp, cap_info.pages);
>> > +               kunmap(cap_info.pages[0]);
>> > +               if (ret) {
>> > +                       pr_err("%s: efi_capsule_update() failed\n", __func__);
>> > +                       efi_free_all_buff_pages(NULL);
>> > +                       return ret;
>> > +               }
>> > +               /* indicate capsule binary uploading is done */
>> > +               cap_info.index = -1;
>>
>> Should count > cap_info.total_size be an error?
>>
>> --Andy
>
> Yes, this is why after the write count already reaches the image size stated in
> efi capsule header, an indicator will be flagged for subsequence write to be
> returned -EIO as what Matt has commented.

What if *this very same write* writes too much data?

--Andy
