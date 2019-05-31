Return-Path: <SRS0=zFTm=T7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAB4C04AB6
	for <linux-efi@archiver.kernel.org>; Fri, 31 May 2019 15:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9EDC26BC0
	for <linux-efi@archiver.kernel.org>; Fri, 31 May 2019 15:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rM6Yk7NI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEaPaq (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 31 May 2019 11:30:46 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40152 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaPaq (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 31 May 2019 11:30:46 -0400
Received: by mail-it1-f196.google.com with SMTP id h11so15878365itf.5
        for <linux-efi@vger.kernel.org>; Fri, 31 May 2019 08:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2517myMErx3IlB/1MwcGTySfyxS/U1aLvsiyOBzFQLg=;
        b=rM6Yk7NIUF2tbA2kv/d7tkwb8UqQbJ7nNBGkaZfISpoO+t0vMxSp0ADkAJQHfDwm0G
         NS1RmxY9UoJp98JKFce4/xJtkzwJOva0zBJ9MmtpHuz3KviIMlkrTPlyMOUSYDBlh9Qr
         LJrO0nxqYzlr/Q/LWaBCjGeYbSnU5xreR8L7ygOUk9ZHF4XN6dJT6wOnOTToqUSNvyPJ
         ZjNEnPWQIMDeJSOIb6I3N6sYDFbcuCPKXaZymtKRUuLTFx7dlevgXDyDup42kQ1KQPBI
         vZ48ZpVrnLymQyClRaJrIwPfygxlaHo531xrRDCRB5JoSaAEhPSF4ndqTXud46CKY5l2
         ONrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2517myMErx3IlB/1MwcGTySfyxS/U1aLvsiyOBzFQLg=;
        b=D9zqGxaTsdWUbbZ51bKumsrj0ezUBhg/WOxyHUuQ33HUDAW8zo2fVfupWbPFqeGouD
         jgHRz1nfBqsRIivcKGny57v3nweXzZwbULiWH3ShbupcfwomaK+TqACg4dQn93d4UsD6
         t3ElxXk7Z0oNvoJbZgT6ebDlZSWetIUU3q0VppwgQ0sinIWIJQc9anEpfRhxSWef0Ggb
         BtZcxX6FGrIqt/ja4y0egfdN651P6fsVa1/VYNwcqRyjqzYgk4qjGNvCGNrA6ZW8QQ52
         lA6Bo1tnAuFHEbDl+JJ3SiMPm98hly+iMY/AZ1DmUc4fpDy3jIARO+vuV2W/I+ZM87Th
         3MJA==
X-Gm-Message-State: APjAAAUkQaMoFPjtPdQwvbHBSDw7AASCtmb9raNOnJxoWpwrV3kdnYo9
        /xEIe9Umcz72On+/9o+Jh0x6Ocs2LEuc2JUWpIZnjSDP
X-Google-Smtp-Source: APXvYqz/rvzlMKEAVtundtKbdzmCd0yGoYdzGKaeAsCdNW9e/4QhtnK5ClxRDBbrihMKn3bVyfSamWkfybMVWqlbMKA=
X-Received: by 2002:a24:1614:: with SMTP id a20mr7052811ita.153.1559316644972;
 Fri, 31 May 2019 08:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <155925716254.3775979.16716824941364738117.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155925718351.3775979.13546720620952434175.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAKv+Gu-J3-66V7UhH3=AjN4sX7iydHNF7Fd+SMbezaVNrZQmGQ@mail.gmail.com> <CAPcyv4g-GNe2vSYTn0a6ivQYxJdS5khE4AJbcxysoGPsTZwswg@mail.gmail.com>
In-Reply-To: <CAPcyv4g-GNe2vSYTn0a6ivQYxJdS5khE4AJbcxysoGPsTZwswg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 31 May 2019 17:30:32 +0200
Message-ID: <CAKv+Gu83QB6x8=LCaAcR0S65WELC-Y+Voxw6LzaVh4FSV3bxYA@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] x86, efi: Reserve UEFI 2.8 Specific Purpose Memory
 for dax
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        kbuild test robot <lkp@intel.com>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Fri, 31 May 2019 at 17:28, Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, May 31, 2019 at 1:30 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > (cc Mike for memblock)
> >
> > On Fri, 31 May 2019 at 01:13, Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > UEFI 2.8 defines an EFI_MEMORY_SP attribute bit to augment the
> > > interpretation of the EFI Memory Types as "reserved for a special
> > > purpose".
> > >
> > > The proposed Linux behavior for specific purpose memory is that it is
> > > reserved for direct-access (device-dax) by default and not available for
> > > any kernel usage, not even as an OOM fallback. Later, through udev
> > > scripts or another init mechanism, these device-dax claimed ranges can
> > > be reconfigured and hot-added to the available System-RAM with a unique
> > > node identifier.
> > >
> > > This patch introduces 3 new concepts at once given the entanglement
> > > between early boot enumeration relative to memory that can optionally be
> > > reserved from the kernel page allocator by default. The new concepts
> > > are:
> > >
> > > - E820_TYPE_SPECIFIC: Upon detecting the EFI_MEMORY_SP attribute on
> > >   EFI_CONVENTIONAL memory, update the E820 map with this new type. Only
> > >   perform this classification if the CONFIG_EFI_SPECIFIC_DAX=y policy is
> > >   enabled, otherwise treat it as typical ram.
> > >
> >
> > OK, so now we have 'special purpose', 'specific' and 'app specific'
> > [below]. Do they all mean the same thing?
>
> I struggled with separating the raw-EFI-type name from the name of the
> Linux specific policy. Since the reservation behavior is optional I
> was thinking there should be a distinct Linux kernel name for that
> policy. I did try to go back and change all occurrences of "special"
> to "specific" from the RFC to this v2, but seems I missed one.
>

OK

> >
> > > - IORES_DESC_APPLICATION_RESERVED: Add a new I/O resource descriptor for
> > >   a device driver to search iomem resources for application specific
> > >   memory. Teach the iomem code to identify such ranges as "Application
> > >   Reserved".
> > >
> > > - MEMBLOCK_APP_SPECIFIC: Given the memory ranges can fallback to the
> > >   traditional System RAM pool the expectation is that they will have
> > >   typical SRAT entries. In order to support a policy of device-dax by
> > >   default with the option to hotplug later, the numa initialization code
> > >   is taught to avoid marking online MEMBLOCK_APP_SPECIFIC regions.
> > >
> >
> > Can we move the generic memblock changes into a separate patch please?
>
> Yeah, that can move to a lead-in patch.
>
> [..]
> > > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > > index 91368f5ce114..b57b123cbdf9 100644
> > > --- a/include/linux/efi.h
> > > +++ b/include/linux/efi.h
> > > @@ -129,6 +129,19 @@ typedef struct {
> > >         u64 attribute;
> > >  } efi_memory_desc_t;
> > >
> > > +#ifdef CONFIG_EFI_SPECIFIC_DAX
> > > +static inline bool is_efi_dax(efi_memory_desc_t *md)
> > > +{
> > > +       return md->type == EFI_CONVENTIONAL_MEMORY
> > > +               && (md->attribute & EFI_MEMORY_SP);
> > > +}
> > > +#else
> > > +static inline bool is_efi_dax(efi_memory_desc_t *md)
> > > +{
> > > +       return false;
> > > +}
> > > +#endif
> > > +
> > >  typedef struct {
> > >         efi_guid_t guid;
> > >         u32 headersize;
> >
> > I'd prefer it if we could avoid this DAX policy distinction leaking
> > into the EFI layer.
> >
> > IOW, I am fine with having a 'is_efi_sp_memory()' helper here, but
> > whether that is DAX memory or not should be decided in the DAX layer.
>
> Ok, how about is_efi_sp_ram()? Since EFI_MEMORY_SP might be applied to
> things that aren't EFI_CONVENTIONAL_MEMORY.

Yes, that is fine. As long as the #ifdef lives in the DAX code and not here.
