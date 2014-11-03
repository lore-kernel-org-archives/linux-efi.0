From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Enable user helper interface for efi capsule update
Date: Mon, 3 Nov 2014 15:08:08 -0800
Message-ID: <CALCETrUtxqLaziC_f6iTEgKNhmTgJR6bOLJ=e=O22X_RsBc9sw@mail.gmail.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <5457D883.4050201@amacapital.net> <20141103212706.GE7379@kroah.com>
 <CALCETrUNCuFvwkzbU4dWB0GH4mJKKV1e6jCNrSLVJe+n_et3kQ@mail.gmail.com> <20141103230234.GA9427@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141103230234.GA9427-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 3, 2014 at 3:02 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Mon, Nov 03, 2014 at 01:32:46PM -0800, Andy Lutomirski wrote:
>> On Mon, Nov 3, 2014 at 1:27 PM, Greg Kroah-Hartman
>> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> > On Mon, Nov 03, 2014 at 11:33:23AM -0800, Andy Lutomirski wrote:
>> >> On 11/02/2014 07:07 PM, Kweh Hock Leong wrote:
>> >> > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
>> >> >
>> >> > Hi Guys,
>> >> >
>> >> > This patchset is created on top of "efi: Capsule update support" patch:
>> >> > http://permalink.gmane.org/gmane.linux.kernel.efi/4837
>> >> >
>> >> > It leverages the request_firmware_nowait() to expose the user helper interface for user to upload the capsule binary and calling the
>> >> > efi_capsule_update() API to pass the binary to EFI firmware.
>> >>
>> >> I don't get it.  Why is the firmware interface at all reasonable for
>> >> uploading capsules?
>> >
>> > Tradition dictates that BIOS updates go through the firmware interface,
>> > that way you don't have to write a new userspace tool, which is a good
>> > thing.
>> >
>> >> The firmware interface makes sense for nonvolatile firmware where
>> >> hotplugging something or otherwise loading a driver needs a blob.
>> >
>> > Or BIOS data.  We've been doing it this way for a long time now.
>>
>> On what system?  Dell?
>
> Yes.
>
>> IMO this sucks from a UI point of view.  When I install wifi firmware,
>> I expect to stick it somewhere and have the driver find it, because
>> the driver knows exactly when it needs the firmware.  When I update my
>> BIOS, I want to click a button or type a command and update my bios.
>
> I agree, it should be "triggered" by something, not just automagically
> loaded whenever the kernel randomly looks for it.
>
>> >> But uploading an EFI capsule is an *action*, not something that should
>> >> happen transparently.  If there's an EFI firmware update available and
>> >> the user wants to install it, then the userspace tool should install it,
>> >> and it shouldn't hang around in /lib/firmware.  In fact, you shouldn't
>> >> even need /lib to be on writable media to use this.
>> >
>> > What does /lib have to do with this?
>>
>> Where else does the file come from, given that udev no longer supports
>> userspace firmware loading?  Is there really some pre-existing tool
>> that pokes it into the sysfs firmware class thing?
>
> Well, you can specify other locations than /lib/firmware/ for firmware
> updates, but yes, you are right, it should be in /lib somewhere.  But
> /lib doesn't need to be writable, it's a read-only file.
>

I assume that whoever downloaded the firmware update will want to
install it, right?  I don't really expect distros to ship EFI capsules
in packages that install to /lib/firmware.  Won't there be userspace
code that either installs a capsule from some URL or uses some future
magical find-my-firmware service?

>> Since EFI capsules are apparently on their way to becoming a
>> ubiquitous mechanism, I think it might be time to rethink
>> request_firmware for this.
>
> What do you suggest instead?  A "custom" sysfs file?  What is going to
> trigger it to be loaded?  A userspace script that someone else has to
> write?  :)

Some ioctl on /dev/efi_capsule seems reasonable to me, or a new script
that uses a custom sysfs file.  Isn't the Dell thing already a rather
custom script?  You write to a custom sysfs file ("rbu_image_type", I
think) and then the handler for that file calls request_firmware.

I think that we can handle a very small C program or script that
uploads the EFI capsule.

Also, FWIW, I think that there are EFI capsules that aren't firmware
updates.  For example, IIRC there's some mechansim that allows you to
pass data to the next OS that boots via a capsule.  It's probably
buggy on every motherboard in existence, but if it ever worked, using
it through /lib/firmware would make no sense.

--Andy
