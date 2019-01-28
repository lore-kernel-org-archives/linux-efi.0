From: Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: Re: [PATCH 2/2] efi/cper: Avoid possible OOB when checking generic
 data block
Date: Mon, 28 Jan 2019 10:04:46 +0000
Message-ID: <d0a78e2a-7114-de25-4515-01844087ddbb@citrix.com>
References: <20190122160912.27312-1-ross.lagerwall@citrix.com>
 <20190122160912.27312-3-ross.lagerwall@citrix.com>
 <20190123115402.GB3227@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190123115402.GB3227@zn.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On 1/23/19 11:54 AM, Borislav Petkov wrote:
> On Tue, Jan 22, 2019 at 04:09:12PM +0000, Ross Lagerwall wrote:
>> When checking a generic status block, we iterate over all the generic
>> data blocks. The loop condition only checks that the start of the
>> generic data block is valid (within estatus->data_length) but not the
>> whole block. Because the size of data blocks (excluding error data) may
>> vary depending on the revision and the revision is contained within the
>> data block, ensure that enough of the current data block is valid before
>> dereferencing any members otherwise an OOB access may occur if
snip
>> -		data_len -= acpi_hest_get_record_size(gdata);
>> +		record_len = acpi_hest_get_record_size(gdata);
> 
> record_size so that it matches the function name it is used to compute
> this.
> 
> Btw, trying to grok this code is making my head spin.
> 
>> +		if (record_len > data_len)
>> +			return -EINVAL;
> 
> <---- newline here.
> 
> Btw, those checks in the loop you can abstract away into a separate
> function so that you end up with something more readable like:
> 
>          apei_estatus_for_each_section(estatus, gdata) {
>                  record_size = check_hest_record_size(gdata, data_len);
>                  if (!record_size)
>                          return -EINVAL;
> 
>                  data_len -= record_size;
>          }
> 
> for example.
> 

There are only two if statements in the loop body -- I don't think it is 
necessary to abstract this into a separate function (which still 
requires having one if statement in the loop body).

I've made the other changes you suggested and sent a V2.

Thanks,
-- 
Ross Lagerwall
