From: ivanhu <ivan.hu@canonical.com>
Subject: Re: [PATCH 1/2] efi/efi_test: use memdup_user
Date: Mon, 8 May 2017 16:18:30 +0800
Message-ID: <0d6b6b9e-de5c-4eb2-f46a-d26ae058fa42@canonical.com>
References: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
 <20170505205349.GC5225@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505205349.GC5225@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Geliang Tang <geliangtang@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org



On 05/06/2017 04:53 AM, Matt Fleming wrote:
> On Sat, 29 Apr, at 09:42:52AM, Geliang Tang wrote:
>> Use memdup_user() helper instead of open-coding to simplify the code.
>>
>> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
>> ---
>>  drivers/firmware/efi/test/efi_test.c | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> This one looks fine. Ivan, do you want to ACK it?
>

Looks fine to me too, ACK. Thanks!

Ivan
