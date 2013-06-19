From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Wed, 19 Jun 2013 01:53:28 -0700
Message-ID: <298f16e6-7ada-4f2e-8dae-f3919e7c8225@email.android.com>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org> <1371139233.6523.272.camel@linux-s257.site> <20130617092107.GA5440@console-pimps.org> <51BEF71402000078000DEC12@nat28.tlf.novell.com> <20130617101745.GB8569@console-pimps.org> <51BF08CD02000078000DEC99@nat28.tlf.novell.com> <20130617123052.GE8569@console-pimps.org> <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com> <51C068C1020000780009C995@nat28.tlf.novell.com> <7BD74F8E52BFD147B6C83AE7A1E893FFE286040C@atlms1.us.megatrends.com> <20130619084329.GA5386@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130619084329.GA5386@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "matt@console-pimps.org" <matt@console-pimps.org>, Zachary Bobroff <zacharyb@ami.com>
Cc: 'Jan Beulich' <jbeulich@suse.com>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>, Joey Lee <JLee@suse.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

The 0xa0000 restriction applies to BIOS really...

"matt@console-pimps.org" <matt@console-pimps.org> wrote:

>On Tue, 18 Jun, at 10:12:22PM, Zachary Bobroff wrote:
>> > Okay, I'm fine with that aspect then. Let's hope everyone plays by
>> > that rule.
>> This is all according to specification, so if they are not following
>> these rules they should be corrected.  The link to where the current
>> public version of the specification is available is here:
>> http://www.uefi.org/specs/agreement
> 
>While I agree that the vendor should be informed if their
>implementation
>deviates from the spec in some way, the Linux kernel usually still
>needs
>to support these nonconforming machines once they end up in the hands
>of
>consumers (which is often the point at which we discover these kinds of
>issues). Sadly, we're still not in a position where firmware updates
>can
>be applied from OEMs ubiquitously, either because machines are End of
>Life'd or because the update needs to be run from Windows.
>
>We tend to adopt the approach of: let's try this until we get reports
>of
>a class of machines where this solution doesn't work.
>
>Though I do find it refreshing to hear engineers talking about the UEFI
>spec in such black and white terms. That is certainly the ideal we
>should be aiming for.
>
>> > Why by one? Splitting some 'free memory' block may result in an
>> > increase by more then one afaict. Assuming the increment can only
>be
>> > one is >implying you having knowledge of the allocator
>> > implementation and behavior, which shouldn't be made use of in
>> > kernel code.
>> We had to actually increment it by two to get it to work correctly.
>> This is all based upon the use of the low_alloc routine in the linux
>> kernel file.  I agree there is still some outstanding issue based
>upon
>> this, but we put it through several different types of tests and it
>> continued to work correctly.  The truest solution would be to us the
>> AllocateMaxAddress parameter when using AllocatePages. 
>
>[...]
>
>> It was my understanding that the point of this was to allocate the
>> memory map below a certain address in memory because the kernel
>> required it.  Matt, can you comment here?  I am not aware of what
>> address it needs to be below, but using this function should do the
>> trick.  Also, if you want to inform me better of what memory ceiling
>> restrictions there are at this early stage of the kernel, I can
>> rewrite the file without the need of the low_alloc routine entirely.
>
>The most important restriction is that all allocations in the EFI boot
>stub need to be below the 1GB mark, because only the first 1GB of
>virtual memory is mapped, unless certain flags are set in the
>xloadflags
>field of the boot_params header. See Documentation/x86/boot.txt.
>
>Further to that, I think I remember some restrictions on the location
>of
>the cmdline pointer - that it needs to be below 0xa0000. Again,
>Documentation/x86/boot.xt should have all the info you need.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
