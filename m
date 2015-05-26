From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: dmi: List SMBIOS3 table before SMBIOS table
Date: Tue, 26 May 2015 19:11:52 +0100
Message-ID: <20150526181152.GA3030@codeblueprint.co.uk>
References: <20150430152305.26b89bd3@endymion.delvare>
 <20150430160401.GF3014@codeblueprint.co.uk>
 <CAKv+Gu-7cakYGoz8oq5CoqgDvLWxyGwAK++yS8A6tvWo5d1taA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-7cakYGoz8oq5CoqgDvLWxyGwAK++yS8A6tvWo5d1taA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Apr, at 06:10:48PM, Ard Biesheuvel wrote:
> 
> I don't have any objections to this patch per se, but I am not crazy
> about the fact that the way the output is ordered is kernel<->userland
> ABI now
> But since there appears to be a precedent with ACPI20 before ACPI,
> that was already the case, apparently.
> So,
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks Ard.

I've thought about this for a long while and we always kinda treat the
results of sysfs files as ABI anyway. If SMBIOS 3 wasn't so new I
wouldn't entertain doing this, but I think it's OK in this situation.

-- 
Matt Fleming, Intel Open Source Technology Center
