From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v2 0/3] efi: add support for non-standard capsule headers
Date: Thu, 20 Apr 2017 10:48:46 +0100
Message-ID: <89abffb4-879a-16d9-42e0-276f75566f29@nexus-software.ie>
References: <cover.1492626781.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1492626781.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Hock Leong Kweh <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>, Sascha Weisenberger <sascha.weisenberger@siemens.com>
List-Id: linux-efi@vger.kernel.org



On 19/04/17 19:32, Jan Kiszka wrote:
> This picks up the patches Ard send before in [1], including the
> "left-over" patches 6..8.
>
> As Ard suggested, I've taken updated patches 6 and 7 of him from [2]
> which address reviewer comments. Furthermore, I've changed patch 8 to
> factor out the Quark quirk logic from the overloaded
> efi_capsule_setup_info as requested by Matt and also applied Andy's
> suggestion to have a quirk dispatcher table with callbacks.
>
> Tested successfully on the IOT2040 - still without a working Galileo
> board.

I'll run it on a Galileo for you today.
