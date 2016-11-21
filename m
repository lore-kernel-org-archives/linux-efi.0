From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 9/9] MODSIGN: Allow the "db" UEFI variable to be suppressed
Date: Mon, 21 Nov 2016 20:33:32 +0100
Message-ID: <CAKv+Gu_R6nio5hNaq3L-RXvfC2F-5ZNxdWLXk5uq9n=c7ETwMg@mail.gmail.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931990959.16460.3038875071067540418.stgit@warthog.procyon.org.uk>
 <CAKv+Gu96ihE7pHrCCeCpy78man-r821b3Vs4Tn_RsYyzY4HV2Q@mail.gmail.com>
 <CA+5PVA7SivAegwxdxuiAFL41Apie4JLK5KbtGGHLr1fP0p3MsQ@mail.gmail.com>
 <CAKv+Gu__wAnOawWZWVF6NF3En0suuFTBrFwwZ5KosqBU8LVHMA@mail.gmail.com>
 <20161121190531.dcha3soohybzaqr6@redhat.com> <CAKv+Gu8RqbHOrbZ+CD0JNf_QFF6=GYnzMtzf5pQ718PTUuy1VQ@mail.gmail.com>
 <20161121191814.fmjzn7c62jgfrtqw@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161121191814.fmjzn7c62jgfrtqw@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 21 November 2016 at 20:18, Peter Jones <pjones@redhat.com> wrote:
> On Mon, Nov 21, 2016 at 08:06:44PM +0100, Ard Biesheuvel wrote:
>> On 21 November 2016 at 20:05, Peter Jones <pjones@redhat.com> wrote:
>> > On Mon, Nov 21, 2016 at 04:42:45PM +0000, Ard Biesheuvel wrote:
>> >> On 21 November 2016 at 16:26, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> >> > On Mon, Nov 21, 2016 at 11:18 AM, Ard Biesheuvel
>> >> > <ard.biesheuvel@linaro.org> wrote:
>> >> >> On 16 November 2016 at 18:11, David Howells <dhowells@redhat.com> wrote:
>> >> >>> From: Josh Boyer <jwboyer@fedoraproject.org>
>> >> >>>
>> >> >>> If a user tells shim to not use the certs/hashes in the UEFI db variable
>> >> >>> for verification purposes, shim will set a UEFI variable called
>> >> >>> MokIgnoreDB.  Have the uefi import code look for this and ignore the db
>> >> >>> variable if it is found.
>> >> >>>
>> >> >>
>> >> >> Similar concern as in the previous patch: it appears to me that you
>> >> >> can DoS a machine by setting MokIgnoreDB if, e.g., its modules are
>> >> >> signed against a cert that resides in db, and shim/mokmanager are not
>> >> >> being used.
>> >> >
>> >> > If shim/mokmanager aren't used, then you can't actually modify
>> >> > MokIgnoreDB.  Again, it requires physical access and a reboot into
>> >> > mokmanager to actually take effect.
>> >> >
>> >>
>> >> This does the trick as well
>> >>
>> >> printf "\x07\x00\x00\x00\x01" >
>> >> /sys/firmware/efi/efivars/MokIgnoreDB-605dab50-e046-4300-abb6-3dd810dd8b23
>> >
>> > So that really means two things.  First, kernel should only honor any of
>> > the Mok* variables if they're Boot Services-only variables.  Second, to
>> > avoid the DoS, shim should create them all as Boot Services-only the
>> > first time it boots.  That'll prevent them from being created post-boot.
>> >
>>
>> All of that assumes you are using shim and mokmanager in the first place.
>
> No, it doesn't.  If you're not using shim, there's no DoS problem,
> because what would you be DoSing?

Well, if I lose the ability to load modules that have been signed with
a key that resides in db, simply because someone managed to set a
variable that the kernel treats as 'special' even though I am not
using shim/mok in the first place, I would call that an effective DoS
if that means I cannot find my root partition anymore. I suppose
checking for the runtime attribute on the MokIgnoreDB variable
mitigates this somewhat, but it still makes me feel uneasy that the
kernel hardwires variable names that are specific to shim/mokmanager
rather than defined by the UEFI spec.

>  And likewise, if you're not using
> Secure Boot at all, you have no guarantee of anything about your boot
> environment, starting with the idea that the boot loader isn't hostile.
> If you're not using Secure Boot, a hostile pre-boot driver could easily
> add DB entries just as easily as MokList entries, or any other
> variables.
>

I am talking about Secure Boot with shim or MokManager, which are
unlikely to be necessary in many cases on ARM/arm64

> The fact that keys can be injected is true with or without this patch,
> though it does make it easier.  But making a boot loader that injects
> keys into the kernel's built-in keyring isn't actually very difficult.
>
> If you're not using firmware enforced SB and shim, you do not have
> security against this.
>

My objection is against 'magic' variables like MokIgnoreDB and
MokListRT, both of which leave gaping security holes if used in the
proposed way on systems that use Secure Boot but are not using shim or
MokManager.

Adding the contents of MokListRT to the set of trusted keys is a *bad*
idea unless I can be 100% sure that shim/mokmanager were involved in
my boot chain.
