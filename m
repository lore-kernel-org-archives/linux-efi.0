From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Tue, 14 Jan 2014 15:25:23 +0000
Message-ID: <CAF7UmSwGgQ9u505s3fhd5MmGLHHy1A=rJLZBshycKr+rTniH1A@mail.gmail.com>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
	<201401140752.33257.arnd@arndb.de>
	<20140114114419.GH30907@bivouac.eciton.net>
	<201401141426.16497.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201401141426.16497.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 January 2014 13:26, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>> > > Are you suggesting that I should #ifndef ARM in common code, or that I
>> > > should neglect to document what the common code will do with data it is
>> > > given by UEFI?
>> >
>> > It would probably be good to document the fact that it won't work,
>> > possibly even having a BUG_ON statement in the code for this case.
>>
>> Why?
>>
>> You'll only touch that pointer if you enable CONFIG_ACPI, and if you
>> do you probably want that address. Sounds a bit hostile to throw a BUG
>> in the face of someone who's (for example) just succeeded to get Linux
>> running on a Windows RT device.
>
> But we know that it can't work unless a lot of other things get changed
> in the kernel.

We know using ACPI cannot work without updates to the kernel.
That doesn't mean we need to throw a BUG just because the
firmware tells us a table exists.

>> Although no other architectures supported by UEFI support big-endian,
>> so to be honest, I don't want to have to be the first one to validate
>> that in order to get the basic support into the kernel.
>
> I think there was a project to run UEFI on PowerPC on some stage, though
> I can't find any code now.

That does sound familiar, but there is nothing in the specification.

/
    Leif
