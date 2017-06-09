From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Fri, 9 Jun 2017 17:33:26 +0000
Message-ID: <CAKv+Gu96h=isM7_-niVmw0pojonD5Sr9Z_onqmkb22GVdH4NVA@mail.gmail.com>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com>
 <21606.1496222635@warthog.procyon.org.uk> <CAKv+Gu_vXASr=yDJ3MwT960eApqeWKEd-hqGoEyGsJKip7N+KQ@mail.gmail.com>
 <25009.1496741691@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25009.1496741691-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(+ Kees)

On 6 June 2017 at 09:34, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> and print a subsequent line for every lockdown feature that is enabled, e.g.,
>>
>> lockdown: disabling MSRs
>> lockdown: disabling hibernate support
>
> There's another problem with this idea: the lockdown facility is passive - it
> doesn't go looking for things to lock down; rather, things that can be locked
> down inquire as to whether lockdown is in effect at the point someone tries to
> use them.
>
> Now, I could reserve a variable for each thing we lock down to make sure that
> we don't emit the message more than once, but I'm loathe to waste memory this
> way.
>
> I can't so easily switch the facility to being active either, since a lot of
> the lockdownables are in modules.
>

Let me reiterate my concern for Kees's sake: without a threat model
nor any notion of how much kernel lockdown reduces the attack surface,
we end up with a 'doing something is better than nothing' approach.
Fine. But now you are telling me that there is no way we can provide
information to the user what that 'something' amounts to for a
particular kernel build for a particular architecture. Do you intend
to add lockdown features going forward after enabling the initial set?
Would any of these lockdown features ever be Kconfigurable? Do you
expect all lockdown features to be applicable to all architectures? So
how do I know what lockdown actually means for my system?

Anyway, I think I have made my concerns clear, and the EFI bits look
fine to me as long as the policy lives elsewhere.

Apologies for letting this drag on a bit. I do agree in principle, but
I'd like to get the details right as well.

Thanks,
Ard.
