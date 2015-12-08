From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 4/7] efi: add nonblocking option to
 efi_query_variable_store()
Date: Tue, 8 Dec 2015 13:44:15 +0000
Message-ID: <20151208134415.GD2518@codeblueprint.co.uk>
References: <1448967020-20190-1-git-send-email-ard.biesheuvel@linaro.org>
 <1448967020-20190-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448967020-20190-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Dec, at 11:50:17AM, Ard Biesheuvel wrote:
> The function efi_query_variable_store() may be invoked by
> efivar_entry_set_nonblocking(), which itself takes care to only call
> a non-blocking version of the SetVariable() runtime wrapper. However,
> efi_query_variable_store() may call the SetVariable() wrapper directly,
> as well as the wrapper for QueryVariableInfo(), both of which could
> deadlock in the same way we are trying to prevent by calling
> efivar_entry_set_nonblocking() in the first place.
> 
> So instead, modify efi_query_variable_store() to use the non-blocking
> variants of both SetVariable() and QueryVariableInfo() if invoked with
> the 'nonblocking' argument set to true.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c | 37 ++++++++++++++------
>  drivers/firmware/efi/vars.c    | 16 +++++++--
>  include/linux/efi.h            | 12 +++++--
>  3 files changed, 49 insertions(+), 16 deletions(-)
 
I get sad everytime I read the EFI vars code. Especially the bits I
wrote :-(

> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 1c7380da65ff..cbe542f5c75d 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -60,16 +60,27 @@ void efi_delete_dummy_variable(void)
>   * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
>   * store.
>   */
> -efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
> +efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
> +				      bool nonblocking)
>  {
>  	efi_status_t status;
>  	u64 storage_size, remaining_size, max_size;
> +	efi_set_variable_t *set_variable;
> +	efi_query_variable_info_t *query_variable_info;
>  
>  	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
>  		return 0;
>  
> -	status = efi.query_variable_info(attributes, &storage_size,
> -					 &remaining_size, &max_size);
> +	if (nonblocking) {
> +		set_variable = efi.set_variable_nonblocking;
> +		query_variable_info = efi.query_variable_info_nonblocking;
> +	} else {
> +		set_variable = efi.set_variable;
> +		query_variable_info = efi.query_variable_info;
> +	}
> +
> +	status = query_variable_info(attributes, &storage_size,
> +				     &remaining_size, &max_size);
 
Could we just return early in the nonblocking case and skip the
attempted garbage collection, e.g.

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380da65ff..4b170c522e8c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -54,13 +54,40 @@ void efi_delete_dummy_variable(void)
 }
 
 /*
+ * In the nonblocking case we do not attempt to perform garbage
+ * collection if we do not have enough free space. Rather, we do the
+ * bare minimum check and give up immediately if the available space
+ * is below EFI_MIN_RESERVE.
+ *
+ * This function is intended to be small and simple because it is
+ * invoked from crash handler paths.
+ */
+static inline efi_status_t
+query_variable_store_nonblocking(u32 attributes, unsigned long size)
+{
+	efi_status_t status;
+	u64 storage_size, remaining_size, max_size;
+
+	status = efi.query_variable_info_nonblocking(attributes, &storage_size
+						     &remaining_size, &max_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (remaining_size - size < EFI_MIN_RESERVE)
+		return EFI_OUT_OF_RESOURCES;
+
+	return EFI_SUCCESS;
+}
+
+/*
  * Some firmware implementations refuse to boot if there's insufficient space
  * in the variable store. Ensure that we never use more than a safe limit.
  *
  * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
  * store.
  */
-efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
+				      bool nonblocking)
 {
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
@@ -68,6 +95,9 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
 		return 0;
 
+	if (nonblocking)
+		return query_variable_store_nonblocking(attributes, size);
+
 	status = efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
