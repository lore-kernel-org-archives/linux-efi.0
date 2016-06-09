From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: kernel param for legacy NVDIMM support
Date: Thu, 9 Jun 2016 13:27:04 -0700
Message-ID: <CAPcyv4i1cq7nqkp=auataYX7oMRFms2z1M94rFxq1fXGAcvHLg@mail.gmail.com>
References: <1465494142-1456010-1-git-send-email-yigal@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465494142-1456010-1-git-send-email-yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, jmoyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 9, 2016 at 10:42 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
> The 'efi_legacy_pmem' parameter will convert EFI persistent memory range
> (type 14) into E820 legacy NVDIMM (type 12) memory range.
>
> Background:
>
> In contrast with the NVDIMM E820 types where we can clearly distinguish
> between old NVDIMMs (type-12) and ACPI 6.0 NVDIMMs (type-7), the EFI
> memory types for NVDIMMs are the same before ACPI 6.0 and after
> (type-14).
> This means that old NVDIMMs under EFI aren't supported even though
> they work fine if booted with BIOS (E820).
>
> So allow the user to explicitly request the kernel to identify NVDIMMs
> as legacy under EFI.
>

I'm concerned with the potential for this command line parameter to
collide with NFIT defined ranges.  At a minimum it should confirm that
there is not already an NFIT describing the same address ranges.

However, we have the ability to override / inject ACPI tables and
methods from the kernel.  Why not use that facility to custom craft an
NFIT when the BIOS fails to provide one?  That way EFI type-14
maintains a constant interpretation as just a reserved memory range
with no other side effects.
