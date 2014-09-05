From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Fri, 05 Sep 2014 08:38:19 +0200
Message-ID: <54095A5B.4030606@redhat.com>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org> <20140904100137.GK3001@console-pimps.org> <5408D299.5000300@zytor.com> <20140904212925.GL3001@console-pimps.org> <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com> <20140905054749.GA4498@ad.chargestorm.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140905054749.GA4498@ad.chargestorm.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Darander <anders@chargestorm.se>, Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt@console-pimps.org>
Cc: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 09/05/14 07:47, Anders Darander wrote:
> * Yinghai Lu <yinghai@kernel.org> [140905 03:19]:
> 
> 
>> On Thu, Sep 4, 2014 at 2:29 PM, Matt Fleming <matt@console-pimps.org> wrote:
>>> On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:
> 
>>>> I am fine with this patch, but at the same time I do want to note that
>>>> there is an alternative to double-buffer the patch and/or (if that
>>>> applies to the buggy BIOS) round up the size of the target buffer.
> 
>>> I'm not sure that rounding up the size of the target buffer will
>>> workaround this issue correctly.
> 
>>> As far as I know, the only thing that Mantas tried was rounding up the
>>> size of the source file, by padding it.
> 
>> Can you try attached patch on top of linus tree?
> 
> I took the liberty to test the patch on my Dell XPS13 9333, and
> unfortunately I got the old hang back. 
> 
> This was tested on the current Linus' tree.

Assuming that the UEFI implementation on Mantas's and Anders's machines
use edk2's FatPkg to read the file from an EFI System Partition:

this kernel patch will have no effect, because FatPkg (the ESP
filesystem driver) checks the buffer size against the remainder of the
file, and clips the input buffer if it would overshoot the file size.

In other words, the rounding up of the kernel will be undone in a
"somewhat higher level" driver in the firmware, and the request size
that reaches DiskIo (the "lowel level driver") remains the same.

https://github.com/tianocore/edk2-FatPkg/blob/master/EnhancedFatDxe/ReadWrite.c#L306

    } else {
      //
      // Access a file
      //
      EndPosition = IFile->Position + *BufferSize;
      if (EndPosition > OFile->FileSize) {
        //
        // The position goes beyond the end of file
        //
        if (IoMode == READ_DATA) {
          //
          // Adjust the actual size read
          //
          *BufferSize -= (UINTN) EndPosition - OFile->FileSize;

Thanks
Laszlo
