From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Wed, 4 Mar 2015 10:56:02 -0800
Message-ID: <CAE9FiQUsCc-Lfo2Tnj4rLspD2sNSLfB53wA_MyxaGDKB3gFf0A@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-5-git-send-email-yinghai@kernel.org>
	<20150304101649.GA3663@pd.tnic>
	<CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 4, 2015 at 10:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Mar 4, 2015 at 2:16 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Wed, Mar 04, 2015 at 12:00:37AM -0800, Yinghai Lu wrote:
>>> commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
>>> is using address as value for kaslr_enabled.
>>>
>>> That will random kaslr_enabled get that set or cleared.
>>> Will have problem for system really have kaslr enabled.
>>>
>>> -v2: update changelog.
>>
>> This is still not good enough. Please do this:
>>
>> In commit f47233c2d34f we did A. The problem with that is B. Change the
>> code to do C.
>>
>> Now you only have to fill out the A,B and C variables with the
>> respective text which is understandable even for people who don't know
>> this code.

Please check if it is ok:

Subject: [PATCH v3] x86, kaslr: get kaslr_enabled back correctly

commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
is using address as value for kaslr_enabled.

That will get wrong value for kaslr_enabled, so have problem for system really
have kaslr enabled.

This patch change to using early map and accessing the value.

-v3: add checking about early_memmap according to bp.
