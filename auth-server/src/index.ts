/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `wrangler dev src/index.ts` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `wrangler publish src/index.ts --name my-worker` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

export interface Env {
	AUTH_KEY: string
	, AUTH_SECRET: string
	// Example binding to KV. Learn more at https://developers.cloudflare.com/workers/runtime-apis/kv/
	// MY_KV_NAMESPACE: KVNamespace;
	//
	// Example binding to Durable Object. Learn more at https://developers.cloudflare.com/workers/runtime-apis/durable-objects/
	// MY_DURABLE_OBJECT: DurableObjectNamespace;
	//
	// Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
	// MY_BUCKET: R2Bucket;
}

function buf2hex(buffer: ArrayBuffer) {
	return [...new Uint8Array(buffer)]
		.map(x => x.toString(16).padStart(2, '0'))
		.join('')
}

export default {
	async fetch(
		request: Request,
		env: Env,
		ctx: ExecutionContext
	): Promise<Response> {

		const date: number = Math.floor(Date.now() / 1000)

		const hash: ArrayBuffer =
			await crypto.subtle.digest("SHA-1", new TextEncoder().encode(env.AUTH_KEY + env.AUTH_SECRET + date))

		const resp: Object = {
			key: env.AUTH_KEY,
			date,
			authorization: buf2hex(hash)
		}

		return new Response(JSON.stringify(resp), {
			headers: {
				'content-type': 'application/json;charset=UTF-8',
			}
		});
	},
};
