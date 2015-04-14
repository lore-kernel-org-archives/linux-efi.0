From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 1/2] firmware_loader: introduce new API - request_firmware_direct_full_path()
Date: Tue, 14 Apr 2015 11:56:26 -0400
Message-ID: <CALCETrW_aXJ1iiXCa6aTE3r3J3EF_Njn5bb9=At_3ajCzPFSPg@mail.gmail.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-2-git-send-email-hock.leong.kweh@intel.com> <20150414140806.GD5989@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150414140806.GD5989@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Ming Lei <ming.lei@canonical.com>, Matt Fleming <matt@console-pimps.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 14, 2015 at 10:08 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 14, 2015 at 05:44:55PM +0800, Kweh, Hock Leong wrote:
>> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
>>
>> Introduce this new API for loading firmware from a specific location
>> instead of /lib/firmware/ by providing a full path to the firmware
>> file.
>
> Ick, why would we want this?
>

Because this mechanism should still work even if /lib is unwriteable
(e.g it's on squashfs or a read-only NFS root).

In this regard, UEFI capsules are very much unlike firmware_class
firmware.  firmware_class firmwise is kind of like device drivers; it
generally comes from the same vendor as your kernel image and
/lib/modules, and it can be updated by the same mechanism.  UEFI
capsules, on the other hand, are one-time things that should be loaded
at the explicit request of the admin.  There is no reason whatsoever
that they should exist on persistent storage, and, in fact, there's a
very good reason that they should not.  On little embedded devices,
which will apparently be the initial users of this code, keeping the
capsules around is a waste of valuable space.

This is why I think that the right approach would be to avoid using
firmware_class entirely for this.  IMO a simple_char device would be
the way to go (hint hint...) but other simple approaches are certainly
possible.

--Andy
