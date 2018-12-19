From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 2/2] efi: efi_guid_t must be 64-bit aligned
Date: Wed, 19 Dec 2018 09:06:37 -0500
Message-ID: <20181219140637.GL2746@sasha-vm>
References: <20181217180214.9436-3-ard.biesheuvel@linaro.org>
 <20181218204116.6D58A2184C@mail.kernel.org>
 <CAKv+Gu8AZ6MemE5Z90L5nvrj51z3=rJ_tF=7Wknzs0_RKk_iOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8AZ6MemE5Z90L5nvrj51z3=rJ_tF=7Wknzs0_RKk_iOQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 19, 2018 at 11:07:53AM +0100, Ard Biesheuvel wrote:
>On Tue, 18 Dec 2018 at 21:41, Sasha Levin <sashal@kernel.org> wrote:
>>
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: all
>>
>> The bot has tested the following trees: v4.19.10, v4.14.89, v4.9.146, v4.4.168, v3.18.130,
>>
>
>Please disregard this patch for -stable until we decide how we are
>going to fix the 32-bit array packing issue.

No worries, we won't take any patches until they are actually upstream.
These mails just help us get more responses with regards to how
backports should be done.
