From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/6] efi: Retrieve Apple device properties
Date: Thu, 4 Aug 2016 16:13:45 +0100
Message-ID: <20160804151345.GM3636@codeblueprint.co.uk>
References: <cover.1469616641.git.lukas@wunner.de>
	<833d193b8a18b0afe168c515e9e56a857ece4bd1.1469616641.git.lukas@wunner.de>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
Content-Disposition: inline
In-Reply-To: <833d193b8a18b0afe168c515e9e56a857ece4bd1.1469616641.git.lukas@wunner.de>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel/>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Sender: "Grub-devel" <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Pierre Moreau <pierre.morrow@free.fr>, grub-devel@gnu.org, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, reverser@put.as, Andreas Noever <andreas.noever@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 28 Jul, at 02:25:41AM, Lukas Wunner wrote:
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index ff574da..7262ee4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -571,6 +571,55 @@ free_handle:
>  	efi_call_early(free_pool, pci_handle);
>  }
>  
> +static void retrieve_apple_device_properties(struct boot_params *params)
> +{
> +	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
> +	struct setup_data *data, *new;
> +	efi_status_t status;
> +	void *properties;
> +	u32 size = 0;
> +
> +	status = efi_early->call(
> +			(unsigned long)sys_table->boottime->locate_protocol,
> +			&guid, NULL, &properties);
> +	if (status != EFI_SUCCESS)
> +		return;
> +
> +	do {
> +		status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> +			size + sizeof(struct setup_data), &new);
> +		if (status != EFI_SUCCESS) {
> +			efi_printk(sys_table,
> +				   "Failed to alloc mem for properties\n");
> +			return;
> +		}
> +		status = efi_early->call(efi_early->is64 ?
> +			((apple_properties_protocol_64 *)properties)->get_all :
> +			((apple_properties_protocol_32 *)properties)->get_all,
> +			properties, new->data, &size);
> +		if (status == EFI_BUFFER_TOO_SMALL)
> +			efi_call_early(free_pool, new);
> +	} while (status == EFI_BUFFER_TOO_SMALL);

Is this looping really required? Do we not know ahead of time what we
expect the size to be? Writing this as a potentially infinite loop (if
broken firmware always returns EFI_BUFFER_TOO_SMALL) is a bad idea.
