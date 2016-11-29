From: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Tue, 29 Nov 2016 10:11:18 -0800
Message-ID: <CAPeXnHs2J2Vcj5vu3G1iP0QcAuSw_1erAUqarALkgf2uhVDEFQ@mail.gmail.com>
References: <20161123134219.GH24624@leverpostej> <20161123104757.GE24624@leverpostej>
 <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
 <18007.1479900357@warthog.procyon.org.uk> <31974.1479910408@warthog.procyon.org.uk>
 <20161123142440.GJ24624@leverpostej> <2794.1479912933@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2794.1479912933-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 6:55 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> > Actually, the two arches have a different interpretation on how to deal
>> > with an error.  Matthew Garrett's original x86 patch assumes that if we
>> > get an error when trying to read SecureBoot and SetupMode that we're *not*
>> > in secure mode, but ARM assumes the opposite.
>>
>> Ok.
>>
>> IIUC, that x86 patch was never upstream, so is there any need to follow
>> that example?
>
> Whilst that may be true, that doesn't mean a lot of people aren't using it.

A conforming implementation that supports secure boot should always
return those variables without error. If they're not present (which is
valid for x86 systems - many predate the feature) then assuming Secure
Boot is disabled is correct. The question of what to do in the event
of other errors is more open, but it wouldn't surprise me if there are
implementations that return non-spec errors for missing variables
under certain circumstances.
