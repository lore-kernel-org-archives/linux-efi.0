From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Thu, 27 Jun 2013 12:04:17 -0600
Message-ID: <51CC7EA1.1040509@wwwdotorg.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org> <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com> <51CB33BE.2020601@wwwdotorg.org> <20130626193158.GF9078@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130626193158.GF9078-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 06/26/2013 01:31 PM, Leif Lindholm wrote:
> On Wed, Jun 26, 2013 at 12:32:30PM -0600, Stephen Warren wrote:
>>>> What about ARMv8? Is the intention to have a separate definition for the
>>>> UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
>>>> future version of UEFI allows LPAE usage?
>>>
>>> It is unlikely that will happen on v7 since newer versions of UEFI are
>>> expected to remain backwards compatible with the current spec.
>>
>> The expectation of backwards-compatibility sounds nice, but it seems a
>> little dangerous to outright rely on it.
>>
>> Even if not a regular compatible property, can we define a property that
>> indicates the UEFI revision or revision of this DT binding, so that if
>> we ever have to change it, there is some way of explicitly indicating
>> which exact schema the DT corresponds to, rather than having to
>> reverse-engineer it from the set of properties that "just happen" to be
>> present in DT?
>>
>> This is rather like the firmware node discussion that happened recently,
>> where we were expecting to represent a firmware (secure mode) interface
>> by a DT node, which would have a compatible value, which in turn would
>> convey information about which "OS" the secure firmware was running, and
>> well as any potential SoC-/OEM-/board-specific interface provided by it.
>>
>> And who knows, what if UEFI gets replaced someday; presumably we'd want
>> some way of explicitly stating "running under UEFI" vs. "running under
>> something else"?
> 
> To me, these concerns are all covered by the existence of the
> efi-system-table node, and the version number that you can extract
> from the table (mandatory in any UEFI implementation) located at that
> address. There is no reverse-engineering involved.

So, what you're saying is that the existence (or lack thereof) of the
efi-system-table property is the indicator whether EFI is present? I
guess if we assume that EFI will always evolve at least compatibly
enough that the system table will always exist and be formatted
identically at least to the extent of allowing the EFI version number to
be parsed then that's workable. If that guarantee is broken, then we can
always define a different property that points at the new format of the
table.

This still seems a little implicit to me; having an explicit node with
an explicit compatible value is much more in line with what's been
discussed for other firmware interfaces.

However, I suppose it will work fine.
