From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL 0/1] EFI mixed mode fix for v4.18
Date: Wed, 11 Jul 2018 12:23:32 +0200
Message-ID: <d857fa53-6c9b-3ebc-25f1-890255b90264@redhat.com>
References: <20180711090235.9327-1-ard.biesheuvel@linaro.org>
 <20180711101303.GA8574@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711101303.GA8574@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
List-Id: linux-efi@vger.kernel.org

Hi,

On 11-07-18 12:13, Ingo Molnar wrote:
> 
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
>> The following changes since commit 1e4b044d22517cae7047c99038abb444423243ca:
>>
>>    Linux 4.18-rc4 (2018-07-08 16:34:02 -0700)
>>
>> are available in the Git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
>>
>> for you to fetch changes up to d7f2e972e702d329fe11d6956df99dfc31211c25:
>>
>>    efi/x86: remove pointless call to PciIo->Attributes() (2018-07-11 10:52:46 +0200)
>>
>> ----------------------------------------------------------------
>> A single fix for the x86 PCI I/O protocol handling code that got
>> broken for mixed mode (64-bit Linux/x86 on 32-bit UEFI) after a
>> fix was applied in -rc2 to fix it for ordinary 64-bit Linux/x86.
> 
> Just curious, because it's unclear from the changelog, what was the symptom, a
> boot hang, instant reboot, or some other misbehavior? Also, what's the scope of
> the fix: were all 64-bit on 32-bit UEFI mixed-mode bootups affected, or only a
> certain subset?

The problem was a reboot (resulting in a boot loop). I may have tested this
on multiple Bay Trail based devices, I don't remember but it was an issue on
Bay Trail devices, which typically use a 32 bit UEFI even though they have a
64 bit capable CPU. There are some rare Bay Trail devices with a 64 bit UEFI
but they are the exception.

Regards,

Hans
