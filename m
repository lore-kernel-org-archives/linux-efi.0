From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Fri, 9 Jun 2017 12:22:13 -0700
Message-ID: <CAGXu5jJ41ea9G8_2Uj04CN-1F==+wohdXkJTr4REVUOXuUbGUw@mail.gmail.com>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com>
 <21606.1496222635@warthog.procyon.org.uk> <CAKv+Gu_vXASr=yDJ3MwT960eApqeWKEd-hqGoEyGsJKip7N+KQ@mail.gmail.com>
 <25009.1496741691@warthog.procyon.org.uk> <CAKv+Gu96h=isM7_-niVmw0pojonD5Sr9Z_onqmkb22GVdH4NVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu96h=isM7_-niVmw0pojonD5Sr9Z_onqmkb22GVdH4NVA@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 9, 2017 at 10:33 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> (+ Kees)
>
> On 6 June 2017 at 09:34, David Howells <dhowells@redhat.com> wrote:
>> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>>> and print a subsequent line for every lockdown feature that is enabled, e.g.,
>>>
>>> lockdown: disabling MSRs
>>> lockdown: disabling hibernate support

If lockdown introspection is desired, perhaps just add a /proc file
that lists them all? And if memory usage is a concern, it could be
behind another config, like CONFIG_LOCK_DOWN_KERNEL_PROC ?

>> There's another problem with this idea: the lockdown facility is passive - it
>> doesn't go looking for things to lock down; rather, things that can be locked
>> down inquire as to whether lockdown is in effect at the point someone tries to
>> use them.
>>
>> Now, I could reserve a variable for each thing we lock down to make sure that
>> we don't emit the message more than once, but I'm loathe to waste memory this
>> way.
>>
>> I can't so easily switch the facility to being active either, since a lot of
>> the lockdownables are in modules.

I personally don't think the introspection is needed, but I see Ard's point.

> Let me reiterate my concern for Kees's sake: without a threat model
> nor any notion of how much kernel lockdown reduces the attack surface,
> we end up with a 'doing something is better than nothing' approach.
> Fine. But now you are telling me that there is no way we can provide
> information to the user what that 'something' amounts to for a
> particular kernel build for a particular architecture. Do you intend
> to add lockdown features going forward after enabling the initial set?
> Would any of these lockdown features ever be Kconfigurable? Do you
> expect all lockdown features to be applicable to all architectures? So
> how do I know what lockdown actually means for my system?

I'd like the kernel to grow a bright line between userspace and
physical memory, so I'm a fan of this series. It does look rather
ad-hoc currently, but I think that's the reality the kernel faces.
Right now, we're in a position where the kernel APIs don't provide a
mechanism to distinguish between userspace users and kernel users (in
that anything can just expose a kernel API to userspace: e.g. all the
drivers over the years that trip over STRICT_DEVMEM and then create
their own /dev/mem without restrictions).

So, as we stand, we need to start by adding lockdown checks everywhere
we find exposures, and I'd expect this list to grow over time (which
would support the desirability of introspection, but I kind of see
introspection as overkill). It'd be nice if we could identify classes
of things that have to keep getting lockdown logic added to so that we
could collect them into a single place (e.g. module parameters that
define a phyiscal memory area could use a helper to do it instead of
being yet another unsigned long, and the helper would do the lockdown
check, etc). But that work will take time.

> Anyway, I think I have made my concerns clear, and the EFI bits look
> fine to me as long as the policy lives elsewhere.

Yeah, splitting policy makes sense to me: Chrome OS would use lockdown
as well, but it doesn't use EFI at all.

> Apologies for letting this drag on a bit. I do agree in principle, but
> I'd like to get the details right as well.

(And please CC me on future versions.)

-Kees

-- 
Kees Cook
Pixel Security
