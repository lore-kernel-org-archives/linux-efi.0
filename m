From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 3 Mar 2015 12:37:54 -0800
Message-ID: <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
 <20150302122955.GB24476@codeblueprint.co.uk> <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Borislav Petkov <bp@alien8.de>, Sam Protsenko <semen.protsenko@linaro.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 2, 2015 at 9:56 PM, Kweh, Hock Leong
<hock.leong.kweh@intel.com> wrote:
>> -----Original Message-----
>> From: Matt Fleming [mailto:matt@console-pimps.org]
>> Sent: Monday, March 02, 2015 8:30 PM
>>
>> On Mon, 02 Mar, at 10:59:00AM, Kweh Hock Leong wrote:
>> > > -----Original Message-----
>> > > From: Borislav Petkov [mailto:bp@alien8.de]
>> > > Sent: Wednesday, February 25, 2015 8:49 PM
>> > >
>> > > On Wed, Feb 25, 2015 at 12:38:20PM +0000, Kweh, Hock Leong wrote:
>> > > > The reason we use this interface for efi capsule is that efi capsule
>> > > > support multi binaries to be uploaded and each binary file name
>> > > > can be different.
>> > >
>> > > So you can write the file path to a second file and reload then, once
>> > > per file.
>> >
>> > Thanks for the suggestion. Did some exploration on this approach and
>> > would like to continue the discussion together with this suggested design.
>> >
>> > Ideal condition:
>> > - one file note is enough for load binary and status return (capsule_load)
>> > - load steps would be as simple as just:
>> >    echo [binary file name] > capsule_load
>> > - status return in the same command action. If failed, the echo will fail
>> >    with the failing status code.
>> >
>> > Trade off:
>> > - does not have the run time flexibility to load any firmware binaries at
>> >    different different path as firmware class  only support one custom
>> >    path inputted during boot time/load time. Unless to add new export
>> >    function for firmware class.
>>
>> Could you elaborate here? I don't understand this point.
>
> Just to call out that using firmware class auto locate binary feature is limited
> to locations:
> - "/lib/firmware/updates/" UTS_RELEASE,
> - "/lib/firmware/updates",
> - "/lib/firmware/" UTS_RELEASE,
> - "/lib/firmware"
> and one custom path which inputted during firmware_class module load
> time or kernel boot up time.
>
> It is just not like the user helper interface which allow load the binary at
> any path/location.
>
> This really is not a big deal. User should cope with it.

No, it's a big deal, and the user should not cope.

The user *should not* be required to have write access to anything in
/lib to install a UEFI capsule that they download from their
motherboard vendor's website.  /lib belongs to the distro, and UEFI
capsules do not belong to the distro.  In this regard, UEFI capsules
are completely unlike your wireless card firmware, your cpu microcode,
etc.

Imagine systems using NFS root, Atomic-style systems (e.g. ostree),
systems that boot off squashfs, etc.  They should still be able to
load capsules.  The basic user interface that should work is:

# uefi-load-capsule /path/to/capsule

or:

# uefi-load-capsule - </path/to/capsule

I don't really care how uefi-load-capsule is implemented, as long as
it's straightforward, because people will screw it up if it isn't
straightforward.

Why is it so hard to have a file in sysfs that you write the capsule
to using *cat* (not echo) and that will return an error code if cat
fails?  Is it because you don't know where the end of the capsule is?
if so, ioctl is designed for exactly this purpose.

TBH, I find this thread kind of ridiculous.  The problem that you're
trying to solve is extremely simple, the functionality that userspace
needs is trivial, and all of these complex proposals for how it should
work are an artifact of the fact that the kernel-internal interfaces
you're using for it are not well suited to the problem at hand.

--Andy
